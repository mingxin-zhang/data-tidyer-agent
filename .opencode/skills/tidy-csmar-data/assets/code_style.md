# Code Style 
When writing R code, always follow these rules:
- Prioritize using functions from the `tidyverse` package, for example: filter, select, left_join.
- Variable names should use underscore notation (snake_case), for example: result_step1, var1_2020.
- Always use pipes (`%>%`) to chain data transformations and pass data forward through each processing step.
- Always use comments to clearly explain what the code does and why.
- When writing functions, always comment on each parameter's type and purpose, and summarize the logic in bullet points.