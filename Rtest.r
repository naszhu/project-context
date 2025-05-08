




# Create a random dataframe in R
set.seed(123) # For reproducibility

random_df <- data.frame(
    ID = 1:10,
    Name = paste("Name", 1:10),
    Age = sample(18:60, 10, replace = TRUE),
    Job = sample(c("Engineer", "Doctor", "Artist", "Teacher"), 10, replace = TRUE),
    Score = runif(10, min = 50, max = 100)
)

# Ensure Age + Job makes a unique combination
random_df <- random_df %>%
    group_by(Age, Job) %>%
    mutate(ID = row_number()) %>%
    ungroup()

# Print the dataframe
print(random_df)

library(dplyr,tidyr)
random_df%>%group_by(Age,Job)%>%
    summarise(snew=mean(Score))

random_df%>%group_by(Age,Job)%>%
    mutate(snew=mean(Score))
