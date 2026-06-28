#!/usr/bin/env python3
"""Preview the structure of a raw CSMAR data file before cleaning.

Usage:
    python3 preview_raw_data.py <data_file>

Supports xlsx and csv formats. Prints shape, column names, dtypes, first 10 rows,
and any non-numeric metadata rows at the top (common in CSMAR exports).
"""

import sys
import pandas as pd


def preview(filepath: str) -> None:
    if filepath.endswith('.xlsx'):
        df = pd.read_excel(filepath)
    elif filepath.endswith('.csv'):
        df = pd.read_csv(filepath)
    else:
        raise ValueError(f'Unsupported format: {filepath}. Use .xlsx or .csv')

    print('=' * 60)
    print(f'File: {filepath}')
    print(f'Shape: {df.shape[0]} rows x {df.shape[1]} cols')
    print('=' * 60)
    print(f'\nColumns: {list(df.columns)}\n')
    print('Dtypes:')
    print(df.dtypes.to_string())
    print(f'\nFirst 10 rows:')
    print(df.head(10).to_string())
    print()

    # Check for potential metadata rows at the top
    # CSMAR data often has 1-3 rows of Chinese description before actual data.
    # A row is metadata if ALL columns contain non-numeric values — real data
    # rows in CSMAR typically have at least one numeric column.
    suspect_rows = []
    for i in range(min(5, len(df))):
        all_non_num = True
        for col in df.columns:
            try:
                pd.to_numeric(df.iloc[i][col])
                all_non_num = False
                break
            except (ValueError, TypeError):
                pass
        if all_non_num:
            suspect_rows.append(i)
    if suspect_rows:
        print(f'Warning: rows {suspect_rows} may be metadata/header rows. '
              f'Consider skipping them when loading data for cleaning.')


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f'Usage: python3 {sys.argv[0]} <data_file>')
        sys.exit(1)
    preview(sys.argv[1])
