# Filename Timestamp
# Processing Steps, for example:
#   - Step 1: Load data
#   - Step 2: Tidy data
#   - Step 3: Save data

# Step 0: Set up
library(tidyverse)
library(haven)
# ......

# Step 1: Load data
# Import the raw data using R
raw_data <- read_xlsx("file path")

# Step 2: Tidy data
# Construct data_step1
data_step1 <- raw_data %>% 
# Filter data
    filter(condition1) %>%
# Select variables
    select(c(var1, var2, var3, var4, var5)) %>%
# Mutate variables
    mutate(v1 = var1 + var2) %>%
# Pivote longer data
    pivot_longer(cols = c(va1, var2, var3), names_to = var4, values_to = v5) %>%
# Leftjoin data
    left_join(data_leftjoin) %>%
# Rbind data
    rbind(data_rbind)
    
# Define function
# A function to do some complex computation
custom_function <- function(data, param1, param2, ...) {
    # data: the data that will be processed
    # param1: the first parameter
    # param2: the second parameter

    # function step1
    # function step2
    # return result
}

# Construct data_step2
data_step2 <- data_step1 %>%
    custom_function(param1, param2)

# Step 3: Save data
data_step2 %>%
    write_dta("./result_data/[task_name]/[Filename].dta")
