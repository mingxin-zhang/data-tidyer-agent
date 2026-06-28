# Filename Timestamp
# Processing Steps, for example:
#   - Step 1: Load data
#   - Step 2: Tidy data
#   - Step 3: Save data

# Step 0: Set up
library(tidyverse)
library(haven)
library(readxl)
library(stringr)

# Step 1: Load data
# Skip metadata rows and assign column names
raw_data <- read_xlsx(
    "raw_data/[data_folder]/[data_file].xlsx",
    skip = [n_metadata_rows],
    col_names = c("col1", "col2", "...")
)

# Step 2: Tidy data
data_clean <- raw_data %>%
    # Filter: keep desired observations
    filter(condition1) %>%
    # Transform: extract year and rename variables
    mutate(
        firm = stock_code_col,
        year = as.numeric(str_sub(date_col, 1, 4)),
        target_var = as.numeric(target_col)
    ) %>%
    # Keep relevant variables
    select(firm, year, target_var) %>%
    # Remove rows with missing values in key variables
    drop_na()

# Step 3: Save intermediate output
data_clean %>%
    write_dta("result_data/[task_name]/[data_name]_clean.dta")
