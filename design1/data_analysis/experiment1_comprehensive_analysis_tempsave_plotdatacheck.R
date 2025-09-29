# ================================
# GLMMs with item-type-specific trends (interactions)
# ================================
library(tidyverse)
library(lme4)
library(broom.mixed)
library(emmeans)

# 0) Load
dfchanged <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis/dfchanged.csv")
cat("Loaded dfchanged data with", nrow(dfchanged), "rows\n")

# 1) Helper: safe poly (always returns *_lin, *_quad)
create_polynomial_terms <- function(data, var_name) {
  v <- suppressWarnings(as.numeric(data[[var_name]]))
  v[is.na(v)] <- mean(v, na.rm = TRUE)
  v_center <- v - mean(v, na.rm = TRUE)
  u <- length(unique(v_center)); n <- length(v_center)
  if (u < 2) {
    out <- data.frame(lin = rep(0, n), quad = rep(0, n))
  } else if (u < 3) {
    lin <- as.numeric(scale(v_center, center = TRUE, scale = TRUE))
    out <- data.frame(lin = lin, quad = rep(0, n))
  } else {
    out <- as.data.frame(poly(v_center, degree = 2, raw = FALSE))
  }
  names(out) <- c(paste0(var_name, "_lin"), paste0(var_name, "_quad"))
  out
}

# 2) Initial test (trial-level) summary and plots

# Prepare initial test data
initial <- dfchanged %>%
  filter(task == "pretest_response", response != "null") %>%
  mutate(
    participant_id = factor(PROLIFIC_PID),
    accuracy = as.numeric(correct),
    study_position = as.numeric(prespos),
    test_position  = as.numeric(testpos),
    list_number    = as.numeric(trialnum),
    item_type = case_when(
      probetype == "TARGET_target" ~ "target",
      probetype == "TARGET_foil"   ~ "foil",
      TRUE ~ NA_character_
    )
  ) %>%
  mutate(item_type = factor(item_type, levels = c("foil","target"))) %>%
  filter(!is.na(participant_id), !is.na(item_type))

# Summarize performance by test position (within-list)
initial_by_testpos <- initial %>%
  group_by(test_position, item_type) %>%
  summarise(
    performance = mean(accuracy, na.rm = TRUE),
    se = sd(accuracy, na.rm = TRUE)/sqrt(n()),
    n = n()
  ) %>%
  ungroup()

# Summarize performance by list number (between-list)
initial_by_listnum <- initial %>%
  group_by(list_number, item_type) %>%
  summarise(
    performance = mean(accuracy, na.rm = TRUE),
    se = sd(accuracy, na.rm = TRUE)/sqrt(n()),
    n = n()
  ) %>%
  ungroup()

# Plot: Within-list (test position)
p_within <- ggplot(initial_by_testpos, aes(x = test_position, y = performance, color = item_type, group = item_type)) +
  geom_line() +
  geom_point() +
  geom_ribbon(aes(ymin = performance - se, ymax = performance + se, fill = item_type), alpha = 0.2, color = NA) +
  labs(
    x = "Test Position (Within List)",
    y = "Mean Correct (Performance)",
    title = "Initial Test: Within-List Position",
    color = "Item Type",
    fill = "Item Type"
  ) +
  theme_bw()

# Plot: Between-list (list number)
p_between <- ggplot(initial_by_listnum, aes(x = list_number, y = performance, color = item_type, group = item_type)) +
  geom_line() +
  geom_point(size = 6) +
  geom_ribbon(aes(ymin = performance - se, ymax = performance + se, fill = item_type), alpha = 0.2, color = NA) +
  labs(
    x = "List Number",
    y = "Mean Correct (Performance)",
    title = "Initial Test: List Number (Between Lists)",
    color = "Item Type",
    fill = "Item Type"
  ) +
  theme_bw()

# Arrange plots side by side with larger, clearer output
library(gridExtra)
# Save to file with larger width/height for clarity
ggsave("initial_test_within_between.png", 
       grid.arrange(p_within, p_between, ncol = 2), 
       width = 25, height = 7, dpi = 300)

# Also show in RStudio/interactive session with larger window
grid.newpage()
grid.draw(arrangeGrob(p_within, p_between, ncol = 2, widths = c(1,1)))

cat("Initial test data prepared:", nrow(initial), "trials\n")

#---------------

# Create summary data for initial test by initial study and test position
initial_long <- initial %>%
  pivot_longer(cols = c(study_position, test_position), names_to = "position_type", values_to = "position") %>%
  filter(!is.na(position))

initial_within_summary <- initial_long %>%
  group_by(position_type, position, item_type) %>%
  summarise(
    mean_accuracy = mean(accuracy, na.rm = TRUE),
    se = sd(accuracy, na.rm = TRUE)/sqrt(n()),
    n = n(),
    .groups = "drop"
  )

# Make position_type labels more readable
initial_within_summary <- initial_within_summary %>%
  mutate(
    position_type = recode(position_type,
                           "study_position" = "Initial Study Position",
                           "test_position" = "Initial Test Position"),
    item_type = recode(item_type,
                       "foil" = "Foil - Correct rejection",
                       "target" = "Target - Hits")
  )

# Plot: Initial test within-list by initial study and test position, faceted
p_initial_within_facet <- ggplot(initial_within_summary, aes(x = position, y = mean_accuracy, color = item_type, group = item_type)) +
  geom_point(size = 3) +
  geom_line(linewidth = 1) +
  geom_ribbon(aes(ymin = mean_accuracy - se, ymax = mean_accuracy + se, fill = item_type), alpha = 0.2, color = NA) +
  facet_grid(. ~ position_type) +
  labs(
    x = "Position",
    y = "Mean Correct (Performance)",
    title = "Initial Test: Within-List by Initial Study/Test Position",
    color = "Item Type",
    fill = "Item Type"
  ) +
  theme_bw(base_size = 18) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = "top"
  )

# Optionally save the plot
# ggsave("initial_test_withinlist_by_study_test_facet.png", p_initial_within_facet, width = 12, height = 6, dpi = 300)
# 3) Final test (trial-level)
# ------------------
# First, create the initial position data like in the reference file
df_initial <- dfchanged %>%
  filter(task == "pretest_response") %>%
  pivot_longer(cols = c(testpos, prespos), names_to = "position_type", values_to = "position") %>%
  select(position, ip, position_type, stimulus_id)

wordlists_intest <- dfchanged %>%
  filter(task == "pretest_response") %>%
  group_by(ip) %>%
  summarize(words = list(stimulus_id))

df_initial_study <- dfchanged %>%
  filter(task == "pretest_study") %>%
  left_join(wordlists_intest, by = "ip") %>%
  rowwise() %>%
  filter(!(stimulus_id %in% unlist(words))) %>% # here get study only
  mutate(position = prespos, position_type = "prespos") %>%
  select(position, position_type, ip, stimulus_id)

df_initial_all <- rbind(df_initial, df_initial_study)

# Create a lookup table with both study and test positions for each item
initial_positions <- df_initial_all %>%
  pivot_wider(names_from = position_type, values_from = position, names_prefix = "initial_") %>%
  select(ip, stimulus_id, initial_prespos, initial_testpos)

# Now create the final test data with correct initial positions
final <- dfchanged %>%
  filter(task == "finalt_response", response != "null") %>%
  select(ip, correct, probetype, stimulus_id, testpos, trialnum, prespos_itrial) %>%
  left_join(initial_positions, by = c("ip", "stimulus_id")) %>%
  mutate(
    participant_id = factor(ip),
    accuracy = as.numeric(correct),
    # define item types
    item_type = case_when(
      probetype == "TARGET_target"    ~ "ST",
      probetype == "TARGET_nontarget" ~ "SO",
      probetype == "TARGET_foil"      ~ "TO",
      probetype == "FOIL"             ~ "foil",
      TRUE ~ NA_character_
    ),
    # Within-list positions from initial test data
    study_position = case_when(item_type %in% c("ST","SO") ~ as.numeric(initial_prespos),
                               TRUE ~ NA_real_),
    test_position  = case_when(item_type %in% c("ST","TO") ~ as.numeric(initial_testpos),
                               TRUE ~ NA_real_),
    # Between-list positions (using final test positions)
    final_order    = case_when(item_type %in% c("ST","TO") ~ as.numeric(cut_number(as.numeric(testpos), 10, labels = 1:10)), 
                               TRUE ~ NA_real_),
    initial_order  = case_when(item_type %in% c("ST","SO") ~ as.numeric(prespos_itrial),
                               TRUE ~ NA_real_)
  ) %>%
  # Remove rows where we couldn't determine positions
  filter(!is.na(study_position) | !is.na(test_position)) %>%
  select(participant_id, accuracy, item_type, study_position, test_position, final_order, initial_order)

# ------------------
# Add polynomial terms
# ------------------
final <- final %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "final_order")) %>%
  bind_cols(create_polynomial_terms(., "initial_order"))

b
# 4) Models (random intercepts; item-type-specific trends via interactions)

# Initial: Study Position × Item Type
m_init_studypos <- glmer(
  accuracy ~ (study_position_lin + study_position_quad) * item_type +
    (1 | participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Initial: Test Position × Item Type
m_init_testpos <- glmer(
  accuracy ~ (test_position_lin + test_position_quad) * item_type +
    (1 | participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Initial: Between-List (List Index) × Item Type
m_init_between <- glmer(
  accuracy ~ (list_number_lin + list_number_quad) * item_type +
    (1 | participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# m_final_within_study <- glmer(
#   accuracy ~ study_position_lin * item_type + study_position_quad * item_type +
#     (1 + study_position_lin + study_position_quad || participant_id),
#   data = final, family = binomial, control = glmerControl(optimizer="bobyqa")
# )


# # Within-list: Test Position
# m_final_within_test <- glmer(
#   accuracy ~ test_position_lin * item_type + test_position_quad * item_type +
#     (1 + test_position_lin + test_position_quad || participant_id),
#   data = final, family = binomial, control = glmerControl(optimizer="bobyqa")
# )

# # Between-list: Final Order
# m_between_final <- glmer(
#   accuracy ~ final_order_lin * item_type + final_order_quad * item_type +
#     (1 + final_order_lin + final_order_quad || participant_id),
#   data = final, family = binomial, control = glmerControl(optimizer="bobyqa")
# )

# # Between-list: Initial Order
# m_between_initial <- glmer(
#   accuracy ~ initial_order_lin * item_type + initial_order_quad * item_type +
#     (1 + initial_order_lin + initial_order_quad || participant_id),
#   data = final, family = binomial, control = glmerControl(optimizer="bobyqa")
# )

# Within-list: Study Position
m_final_within_study <- glmer(
  accuracy ~ study_position_lin * item_type + study_position_quad * item_type +
    (1 | participant_id) + (0 + study_position_lin | participant_id) + (0 + study_position_quad | participant_id),
  data = final, family = binomial, control = glmerControl(optimizer="bobyqa"),
  na.action = na.omit
)

# Within-list: Test Position
m_final_within_test <- glmer(
  accuracy ~ test_position_lin * item_type + test_position_quad * item_type +
    (1 | participant_id) + (0 + test_position_lin | participant_id) + (0 + test_position_quad | participant_id),
  data = final, family = binomial, control = glmerControl(optimizer="bobyqa"),
  na.action = na.omit
)

# Between-list: Final Order
m_between_final <- glmer(
  accuracy ~ final_order_lin * item_type + final_order_quad * item_type +
    (1 | participant_id) + (0 + final_order_lin | participant_id) + (0 + final_order_quad | participant_id),
  data = final, family = binomial, control = glmerControl(optimizer="bobyqa"),
  na.action = na.omit
)

# Between-list: Initial Order
m_between_initial <- glmer(
  accuracy ~ initial_order_lin * item_type + initial_order_quad * item_type +
    (1 | participant_id) + (0 + initial_order_lin | participant_id) + (0 + initial_order_quad | participant_id),
  data = final, family = binomial, control = glmerControl(optimizer="bobyqa"),
  na.action = na.omit
)

# Check all models for convergence
models <- list(m_final_within_study, m_final_within_test, m_between_final, m_between_initial)
# Add diagnostic information about observations used in each model
cat("Model observation counts:\n")
cat("Study position model:", nrow(model.frame(m_final_within_study)), "observations\n")
cat("Test position model:", nrow(model.frame(m_final_within_test)), "observations\n")
cat("Final order model:", nrow(model.frame(m_between_final)), "observations\n")
cat("Initial order model:", nrow(model.frame(m_between_initial)), "observations\n")
for (i in seq_along(models)) {
  if (!models[[i]]@optinfo$convergence) {
    cat(paste0("Model ", i, " did not converge! Trying different optimizer...\n"))
    models[[i]] <- update(models[[i]], 
                         control = glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE))
  }
}

# Final: Test Chunk (same as test_position model; kept for symmetry if you use chunking)
m_final_testchunk <- m_final_testpos
# ------------------
# 5) Summaries (fixed effects)
# ------------------
results <- list(
  init_studypos        = broom.mixed::tidy(m_init_studypos,        effects = "fixed", conf.int = TRUE),
  init_testpos         = broom.mixed::tidy(m_init_testpos,         effects = "fixed", conf.int = TRUE),
  init_between         = broom.mixed::tidy(m_init_between,         effects = "fixed", conf.int = TRUE),
  final_within_study   = broom.mixed::tidy(m_final_within_study,   effects = "fixed", conf.int = TRUE),
  final_within_test    = broom.mixed::tidy(m_final_within_test,    effects = "fixed", conf.int = TRUE),
  final_between_final  = broom.mixed::tidy(m_between_final,        effects = "fixed", conf.int = TRUE),
  final_between_initial= broom.mixed::tidy(m_between_initial,      effects = "fixed", conf.int = TRUE)
)

# ------------------
# 6) Item-type–specific linear & quadratic trends (simple slopes)
# ------------------
trends <- list(
  # Initial test
  init_studypos_lin   = emtrends(m_init_studypos,   ~ item_type, var = "study_position_lin"),
  init_studypos_quad  = emtrends(m_init_studypos,   ~ item_type, var = "study_position_quad"),
  init_testpos_lin    = emtrends(m_init_testpos,    ~ item_type, var = "test_position_lin"),
  init_testpos_quad   = emtrends(m_init_testpos,    ~ item_type, var = "test_position_quad"),
  init_between_lin    = emtrends(m_init_between,    ~ item_type, var = "list_number_lin"),
  init_between_quad   = emtrends(m_init_between,    ~ item_type, var = "list_number_quad"),

  # Final test (within-list)
  final_within_study_lin  = emtrends(m_final_within_study, ~ item_type, var = "study_position_lin"),
  final_within_study_quad = emtrends(m_final_within_study, ~ item_type, var = "study_position_quad"),
  final_within_test_lin   = emtrends(m_final_within_test,  ~ item_type, var = "test_position_lin"),
  final_within_test_quad  = emtrends(m_final_within_test,  ~ item_type, var = "test_position_quad"),

  # Final test (between-list)
  final_between_final_lin   = emtrends(m_between_final,   ~ item_type, var = "final_order_lin"),
  final_between_final_quad  = emtrends(m_between_final,   ~ item_type, var = "final_order_quad"),
  final_between_initial_lin = emtrends(m_between_initial, ~ item_type, var = "initial_order_lin"),
  final_between_initial_quad= emtrends(m_between_initial, ~ item_type, var = "initial_order_quad")
)

# Convert emtrends results to data frames safely
trends_df <- lapply(trends, function(x) tryCatch(as.data.frame(x), error = function(e) NULL))

# ------------------
# 7) Save
# ------------------
saveRDS(
  list(
    models = list(
      m_init_studypos       = m_init_studypos,
      m_init_testpos        = m_init_testpos,
      m_init_between        = m_init_between,
      m_final_within_study  = m_final_within_study,
      m_final_within_test   = m_final_within_test,
      m_between_final       = m_between_final,
      m_between_initial     = m_between_initial
    ),
    summaries = results,
    trends    = trends_df
  ),
  "experiment1_glmm_full_with_interactions.rds"
)

# Also export flat CSV for reporting
bind_rows(
  results$init_studypos          %>% mutate(model = "init_studypos"),
  results$init_testpos           %>% mutate(model = "init_testpos"),
  results$init_between           %>% mutate(model = "init_between"),
  results$final_within_study     %>% mutate(model = "final_within_study"),
  results$final_within_test      %>% mutate(model = "final_within_test"),
  results$final_between_final    %>% mutate(model = "final_between_final"),
  results$final_between_initial  %>% mutate(model = "final_between_initial")
) %>%
  write_csv("all_model_summaries_with_interactions.csv")

# Tidy & save item-type trends (if any computed)
compact_trends <- purrr::imap_dfr(trends_df, ~{
  if (is.null(.x)) return(NULL)
  as_tibble(.x) %>% mutate(contrast = .y)
})
if (nrow(compact_trends) > 0) write_csv(compact_trends, "all_itemtype_trends.csv")

cat("Saved: experiment1_glmm_full_with_interactions.rds\n")
cat("Saved: all_model_summaries_with_interactions.csv\n")
if (exists("compact_trends") && nrow(compact_trends) > 0) cat("Saved: all_itemtype_trends.csv\n")
