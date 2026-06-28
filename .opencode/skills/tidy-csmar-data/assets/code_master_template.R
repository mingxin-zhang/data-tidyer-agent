# [task_name] master
# Merge control script. Sources all cleaning scripts, loads intermediate
# outputs, executes the merge, and saves the final result.
#
# Processing Steps:
#   - Step 1: Source cleaning scripts
#   - Step 2: Load intermediate data
#   - Step 3: Merge and compute derived variables
#   - Step 4: Save final output

# Step 0: Set up
library(tidyverse)
library(haven)

# Step 1: Source all cleaning scripts
# Each script reads raw_data → outputs result_data/[task_name]/[data]_clean.dta
source("code/[task_name]/clean_data1.R")
source("code/[task_name]/clean_data2.R")
source("code/[task_name]/clean_data3.R")
# source("code/[task_name]/clean_data4.R")  # Add new data here

# Step 2: Load intermediate outputs
data1 <- read_dta("result_data/[task_name]/data1_clean.dta")
data2 <- read_dta("result_data/[task_name]/data2_clean.dta")
data3 <- read_dta("result_data/[task_name]/data3_clean.dta")
# data4 <- read_dta("result_data/[task_name]/data4_clean.dta")  # Add new data here

# Step 3: Merge all data
merged <- data1 %>%
    left_join(data2, by = c("firm", "year")) %>%
    left_join(data3, by = c("firm", "year")) %>%
    # left_join(data4, by = c("firm", "year"))  # Add new data here
    mutate(age = year - list_year)

# Step 4: Save final output
merged %>%
    write_dta("result_data/[task_name]/merged.dta")
