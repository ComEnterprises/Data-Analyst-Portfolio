"""
Coffee Shop Analytics Project

Script: 01_load_data.py

Purpose:
Load the Coffee Shop Sales dataset into pandas and take
an initial look at the data before cleaning or analysis.
"""

import pandas as pd

# Path to the dataset
CSV_FILE = r"c:\Users\colli\Downloads\Coffee_Shop_Analysis(Raw Data) (2).csv"


def load_data(file_path):
    """Read the CSV file into a DataFrame."""
    return pd.read_csv(file_path)


def inspect_data(df):
    """Print a quick overview of the dataset."""

    print("\nCoffee Shop Sales Dataset")
    print("-" * 40)

    print(f"\nRows, Columns: {df.shape}")

    print("\nColumn Names")
    print(df.columns.tolist())

    print("\nData Types")
    print(df.dtypes)

    print("\nFirst 5 Rows")
    print(df.head())

    print("\nLast 5 Rows")
    print(df.tail())

    print("\nSummary Statistics")
    print(df.describe())

    print("\nMissing Values")
    print(df.isna().sum())

    print("\nDuplicate Rows")
    print(df.duplicated().sum())


def main():

    print("Loading coffee shop sales data...")

    sales = load_data(CSV_FILE)

    print("Dataset loaded successfully.")

    inspect_data(sales)


if __name__ == "__main__":
    main()