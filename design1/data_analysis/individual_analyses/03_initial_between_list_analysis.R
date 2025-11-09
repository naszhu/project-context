# ================================
# Initial Test: Between-List (List Number) Analysis
# ================================

# Load shared setup
source("00_shared_setup.R")

# Load data
dfchanged <- read_csv("../dfchanged.csv")
cat("Loaded dfchanged data with", nrow(dfchanged), "rows\n")

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
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "list_number")) %>%
  filter(!(rt < 150 | rt > 3500))

# Summarize means and SE by list number and item type
summary_by_list <- initial %>%
  group_by(list_number, item_type) %>%
  summarise(
    mean_acc = mean(accuracy, na.rm=TRUE),
    se_acc = sd(accuracy, na.rm=TRUE)/sqrt(n())
  ) %>%
  ungroup()

# Set plot style to match image
item_palette <- c(
  "target" = "#FFA500",    # Orange for targets
  "foil"   = "#377EB8"     # Blue for foils
)
item_shape <- c(
  "target" = 17,  # triangle for targets
  "foil"   = 15   # square for foils
)

# For dashed mid-line, average the two item_types at each list_number
summary_wide <- tidyr::pivot_wider(summary_by_list, names_from = item_type, values_from = mean_acc)
summary_wide <- summary_wide %>% mutate(mid = (`foil` + `target`)/2)

# Create the ggplot
library(ggplot2)

gg_between <- ggplot() +
  geom_ribbon(
    data = subset(summary_by_list, item_type == "foil"),
    aes(x = list_number, ymin = mean_acc - se_acc, ymax = mean_acc + se_acc),
    fill = item_palette["foil"], alpha = 0.25
  ) +
  geom_ribbon(
    data = subset(summary_by_list, item_type == "target"),
    aes(x = list_number, ymin = mean_acc - se_acc, ymax = mean_acc + se_acc),
    fill = item_palette["target"], alpha = 0.25
  ) +
  geom_line(
    data = summary_by_list,
    aes(x = list_number, y = mean_acc, color = item_type, group = item_type),
    linewidth = 1.5
  ) +
  geom_line(
    data = summary_wide,
    aes(x = list_number, y = mid), color = "black", linetype = "dashed", linewidth = 1.2
  ) +
  geom_point(
    data = summary_by_list,
    aes(x = list_number, y = mean_acc, color = item_type, shape = item_type),
    size = 3, stroke = 1.1
  ) +
  scale_color_manual(
    values = item_palette,
    breaks = c("target", "foil"),
    labels = c("Target", "Foil")
  ) +
  scale_fill_manual(
    values = item_palette,
    guide = "none"
  ) +
  scale_shape_manual(
    values = item_shape,
    breaks = c("target", "foil"),
    labels = c("Target", "Foil")
  ) +
  scale_x_continuous(
    breaks = seq(1, 10, 1),
    limits = c(1, 10),
    name = "List number in initial test"
  ) +
  scale_y_continuous(
    breaks = seq(0.80, 0.96, 0.04),
    limits = c(0.80, 0.96),
    name = "Correct Response Rate"
  ) +
  labs(
    title   = "E1 Initial Between List DATA"
  ) +
  theme_minimal(base_size = 16) +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 18, hjust = 0.5, face = "bold"),
    axis.title.x = element_text(size = 15),
    axis.title.y = element_text(size = 15),
    axis.text = element_text(size = 12)
  )

ggsave("03_initial_between_list_plot.png", plot = gg_between, width = 8, height = 5, dpi = 300)

cat("Initial test data prepared:", nrow(initial), "trials\n")

# Validate position data
validate_position_data(initial, "list_number")

# Fit model: List Number × Item Type
m_init_between <- glmer(
  accuracy ~ (list_number_lin + list_number_quad) * item_type +
    (1 | participant_id) + (0 + list_number_lin | participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa"),
  na.action = na.omit
)

# Check convergence
cat("\n=== Initial Between-List Model ===\n")
check_convergence_issues(m_init_between)

# Get fixed effects summary
results <- broom.mixed::tidy(m_init_between, effects = "fixed", conf.int = TRUE)

# Get item-type-specific trends
cat("\n=== Item-Type-Specific Trends ===\n")
between_lin_trend <- emtrends(m_init_between, ~ item_type, var = "list_number_lin")
between_quad_trend <- emtrends(m_init_between, ~ item_type, var = "list_number_quad")
print("Linear Trends:")
print(between_lin_trend)
print("Quadratic Trends:")
print(between_quad_trend)

# Get marginal means and pairwise comparisons
cat("\n=== Item Type Comparisons ===\n")
between_emmeans <- emmeans(m_init_between, ~ item_type)
between_pairs <- pairs(between_emmeans, adjust = "tukey")
print("Estimated Marginal Means:")
print(as.data.frame(between_emmeans))
print("\nPairwise Comparisons:")
print(between_pairs)

# Save results
saveRDS(
  list(
    model = m_init_between,
    summary = results,
    linear_trends = as.data.frame(between_lin_trend),
    quadratic_trends = as.data.frame(between_quad_trend),
    emmeans = as.data.frame(between_emmeans),
    pairwise = as.data.frame(between_pairs)
  ),
  "init_between_model.rds"
)

# Export summary as CSV
results %>%
  mutate(model = "init_between") %>%
  write_csv("init_between_summary.csv")

cat("\nSaved: init_between_model.rds\n")
cat("Saved: init_between_summary.csv\n")
