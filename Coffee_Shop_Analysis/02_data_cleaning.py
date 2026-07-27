"""
Coffee Shop Analytics Project

Script: 02_data_cleaning.py

Purpose:
Clean the sales data and run basic validation checks
before using it for analysis.

Author:
Collin Quaintance
"""

from pathlib import Path
import pandas as pd

# Configuration

CSV_FILE = r"C:\Users\colli\Downloads\Coffee_Shop_Analysis(Raw Data) (2).csv"

OUTPUT_DIR = Path("../outputs")
OUTPUT_DIR.mkdir(exist_ok=True)

OUTPUT_FILE = OUTPUT_DIR / "clean_sales.csv"

# Load Data

def load_data():
    """Read the dataset and standardize column names."""

    df = pd.read_csv(
        CSV_FILE,
        parse_dates=["transaction_date"]
    )

    # Standardize column names
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )

    return df


# Inspect Dataset

def inspect_dataset(df):
    """Display basic dataset information."""

    print("\nCoffee Shop Sales Dataset")
    print("-" * 40)

    print(f"Rows: {len(df):,}")
    print(f"Columns: {len(df.columns)}")

    print("\nColumn Names")
    print(df.columns.tolist())

    print("\nData Types")
    print(df.dtypes)

    print("\nMissing Values")
    print(df.isna().sum())

    print("\nDuplicate Rows")
    print(df.duplicated().sum())


# Remove Duplicates

def remove_duplicates(df):
    """Remove duplicate rows."""

    before = len(df)

    df = df.drop_duplicates()

    after = len(df)

    print(f"\nRows before cleaning : {before:,}")
    print(f"Rows after cleaning  : {after:,}")
    print(f"Duplicates removed   : {before - after:,}")

    return df



# Validate Numeric Columns

def validate_numeric_columns(df):
    """Check for invalid numeric values."""

    print("\nChecking numeric fields...")

    print(f"Negative revenue: {len(df[df['revenue'] < 0])}")
    print(f"Negative prices: {len(df[df['unit_price'] < 0])}")
    print(f"Invalid quantities: {len(df[df['transaction_qty'] <= 0])}")



# Validate Revenue

def validate_revenue(df):
    """Check whether revenue equals quantity × unit price."""

    calculated = (
        df["transaction_qty"] *
        df["unit_price"]
    ).round(2)

    invalid = df[calculated != df["revenue"]]

    print(f"\nRevenue validation failures: {len(invalid)}")

    if len(invalid) > 0:
        print("\nSample invalid rows:")
        print(invalid.head())

    return invalid


# Export Clean Data

def export_clean_data(df):
    """Export cleaned dataset."""

    df.to_csv(
        OUTPUT_FILE,
        index=False
    )

    print(f"\nClean dataset exported to:")
    print(OUTPUT_FILE)


# Main

def main():

    print("Loading Coffee Shop sales data...")

    sales = load_data()

    print(f"Loaded {len(sales):,} records successfully.")

    inspect_dataset(sales)

    sales = remove_duplicates(sales)

    validate_numeric_columns(sales)

    validate_revenue(sales)

    export_clean_data(sales)

    print("\nData cleaning completed successfully.")


if __name__ == "__main__":
    main()