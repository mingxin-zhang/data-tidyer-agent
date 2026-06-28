---
name: tidy-csmar-data
description: Tidy CSMAR data using R. Use when you have CSMAR data that needs to be cleaned and organized for analysis.
---
# Tidy CSMAR Data

This skill helps users tidy CSMAR data using R. It takes raw CSMAR data and performs cleaning and organization to make it ready for analysis.

## Design Principle: Task-based Modular Organization

Each analysis task is isolated in its own directory. Individual cleaning scripts are single-responsibility (one data source → one intermediate output). The master script orchestrates the merge, giving a single place to review the full join context.

```
code/
└── [task_name]/              # One folder per analysis task
    ├── master.R              # Entry point: sources scripts, merges all data
    ├── clean_assets.R        # Cleaning script: raw → intermediate .dta
    ├── clean_leverage.R
    └── ...

result_data/
└── [task_name]/              # Intermediate and final outputs
    ├── assets_clean.dta
    ├── leverage_clean.dta
    └── merged.dta

review/
└── [task_name]/              # Review feedback
    └── review_master.md
```

This design solves two problems:

1. **Context review**: All join logic lives in a single `master.R`, making cross-script consistency easy to audit.
2. **Incremental maintenance**: Adding new data means writing one cleaning script + adding one `left_join` line in master. Existing scripts are untouched.

---

## Input

- Raw CSMAR data in a format such as CSV or Excel.
- A file containing variable names and definitions for the CSMAR data in txt format.
- User specifications for how to tidy the data, such as which columns to keep, how to handle missing values, and any specific transformations needed.

---

## Workflow A: New Analysis Task

### Step A1: Confirm key information

- MUST confirm with user about the name of each data file to be tidied.
- MUST confirm with user about the name of each variable definitions file.
- MUST confirm with user about a **task name** for the code folder.

### Step A2: Preview raw data structure

- Use `./scripts/preview_raw_data.py` to inspect each raw data file:
  ```bash
  python3 .opencode/skills/tidy-csmar-data/scripts/preview_raw_data.py <path_to_data_file>
  ```
- The script outputs: shape, column names, dtypes, first 10 rows, and metadata row warnings.
- Use this output to understand each dataset's structure.

### Step A3: Plan processing steps

- It is NECESSARY to confirm with the user whether the planned data processing steps align with the user's objectives.
- If the answer is No, MUST ask the user to supply information about how to fix it, and then plan the steps again.
- If the user confirms that the steps are appropriate, proceed to the next step.

### Step A4: Create project structure

- Create the following directories:
  - `code/[task_name]/`
  - `result_data/[task_name]/`
  - `review/[task_name]/`

### Step A5: Write cleaning scripts

- Write one cleaning script per data source, following `./assets/code_clean_template.R`.
- Each script reads from `raw_data/`, writes to `result_data/[task_name]/[data_name]_clean.dta`.
- Each script produces exactly two variables: firm + one target variable (plus year when temporal).

### Step A6: Write master.R

- Write `code/[task_name]/master.R` following `./assets/code_master_template.R`.
- Sources all cleaning scripts, loads intermediates, executes the merge, saves final output.
- The merge logic and all joins are centralized here.

### Step A7: Review R Code

- Pass the following information to the `code-reviewer` subagent:
  - The user's intent and the confirmed processing steps.
  - The coding style outlined in `./assets/code_style.md`.
  - The output templates in `./assets/code_clean_template.R` and `./assets/code_master_template.R`.
  - All code files under `code/[task_name]/`.
- Review using the `code-reviewer` subagent.

### Step A8: Fix R Code

- Read the feedback saved in `./review/[task_name]/review_[task_name].md`.
- Fix all issues classified as Error.
- Address all Warning items.
- Leave all Correct items unchanged.
- Add a comment at the beginning of each code file: `# Code has been reviewed and revised.`

### Step A9: Run R Code

- Execute `code/[task_name]/master.R`.
- Verify the output at `result_data/[task_name]/merged.dta`.

---

## Workflow B: Adding Data to Existing Task

### Step B1: Confirm new data

- MUST confirm the new data file name, variable definitions file, and which variables to extract.
- MUST confirm the existing task name and which master.R to extend.

### Step B2: Preview and plan

- Run `./scripts/preview_raw_data.py` on the new data file.
- Plan the cleaning steps and how it joins into the existing merge (e.g., `inner_join` vs `left_join`).
- Confirm the plan with the user.

### Step B3: Write new cleaning script

- Write a new cleaning script in `code/[task_name]/` following `./assets/code_clean_template.R`.
- Save the intermediate output to `result_data/[task_name]/[data_name]_clean.dta`.

### Step B4: Update master.R

- Add a `source()` line to load the new cleaning script.
- Add a `read_dta()` line to load the intermediate output.
- Add a `[join_type]_join()` line in the merge pipeline.
- Add any new derived variables if needed.

### Step B5: Review, fix, and run

- Review the new cleaning script and the updated master.R using `code-reviewer`.
- Fix all issues, then execute master.R.

---

## Constraints
- Never skip the confirmation step.
- Never skip the code review step. 
- Always remove text description rows and blank rows from the data.
- Always remove rows with missing values in key continuous variables.
- Always use year-end (12-31) observations for quarterly/annual data — filter with `str_detect(date_col, "-12-31$")`.
- For the following categorical variables, always confirm the user's choice:
  - Financial statement type (Typrep: A=consolidated, B=parent)
  - Whether to exclude ST, *ST, or PT stocks
  - Whether to exclude companies listed for less than one year
  - Whether to exclude delisted or suspended companies
  - Whether to exclude companies listed on the Beijing Stock Exchange
- When merging, unless the user specifies otherwise, default to using the dataset with the largest valid firm-year observations as the base for the first join, and default to `left_join` to preserve maximum observations.
- If many-to-many or one-to-many relationships arise during merging, inform the user and ask how to proceed before continuing.
