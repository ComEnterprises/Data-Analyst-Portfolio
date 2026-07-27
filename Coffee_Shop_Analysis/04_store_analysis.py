"""
Coffee Shop Analytics Project

Script: 04_store_analysis.py

Purpose:
Analyze sales performance across each store location and
generate a summary of key business metrics for reporting.

Author:
Collin Quaintance
"""

from pathlib import Path
import pandas as pd

# Configuration

CSV_FILE = Path("../outputs/clean_sales.csv")

OUTPUT_DIR = Path("../outputs")
OUTPUT_DIR.mkdir(exist_ok=True)

OUTPUT_FILE = OUTPUT_DIR / "store_summary.csv"


# Load Data

def load_data():
    """Load the cleaned sales dataset."""

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


# Store Analysis

def analyze_stores(df):
    """Summarize performance for each store."""

    summary = (
        df.groupby("store_location")
        .agg(
            total_revenue=("revenue", "sum"),
            total_transactions=("transaction_id", "count"),
            units_sold=("transaction_qty", "sum"),
            average_order_value=("revenue", "mean"),
            average_unit_price=("unit_price", "mean")
        )
        .reset_index()
    )

    # Calculate each store's percentage of total revenue
    summary["revenue_share"] = (
        summary["total_revenue"]
        / summary["total_revenue"].sum()
        * 100
    ).round(2)

    # Rank stores by revenue
    summary["revenue_rank"] = (
        summary["total_revenue"]
        .rank(method="dense", ascending=False)
        .astype(int)
    )

    # Sort from highest to lowest revenue
    summary = summary.sort_values(
        by="total_revenue",
        ascending=False
    )

    return summary


# Export Results

def save_results(summary):
    """Save the store summary."""

    summary.to_csv(
        OUTPUT_FILE,
        index=False
    )

    print(f"\nStore summary exported to:\n{OUTPUT_FILE}")


# Main

def main():

    print("Loading cleaned sales data...")

    sales = load_data()

    print(f"Loaded {len(sales):,} sales records.")

    print("\nAnalyzing store performance...")

    store_summary = analyze_stores(sales)

    print("\nStore Performance Summary")
    print("-" * 40)
    print(store_summary)

    save_results(store_summary)

    print("\nStore analysis completed successfully.")


if __name__ == "__main__":
    main()