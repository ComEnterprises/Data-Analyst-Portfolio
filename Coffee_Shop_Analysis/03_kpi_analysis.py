"""
Coffee Shop Analytics Project

Script: 03_kpi_analysis.py

Purpose:
Calculate key business performance metrics from the
Coffee Shop Sales dataset and export the results for
reporting.

Author:
Collin Quaintance
"""

from pathlib import Path
import pandas as pd

# Configuration

CSV_FILE = r"C:\Users\colli\Downloads\Coffee_Shop_Analysis(Raw Data) (2).csv"

OUTPUT_DIR = Path("../outputs")
OUTPUT_DIR.mkdir(exist_ok=True)

OUTPUT_FILE = OUTPUT_DIR / "kpi_summary.csv"


# Load Data

def load_data():
    """Load the sales dataset into a pandas DataFrame."""

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


# KPI Calculations

def calculate_kpis(df):
    """Calculate the primary business KPIs."""

    total_revenue = df["revenue"].sum()
    total_transactions = len(df)
    total_units = df["transaction_qty"].sum()

    metrics = {
        "Total Revenue": total_revenue,
        "Total Transactions": total_transactions,
        "Total Units Sold": total_units,
        "Average Order Value": total_revenue / total_transactions,
        "Revenue Per Item": total_revenue / total_units,
        "Average Unit Price": df["unit_price"].mean(),
        "Largest Transaction": df["revenue"].max(),
        "Smallest Transaction": df["revenue"].min(),
        "Distinct Products": df["product_id"].nunique(),
        "Distinct Stores": df["store_location"].nunique()
    }

    return pd.DataFrame(
        metrics.items(),
        columns=["Metric", "Value"]
    )


# Save Results

def save_results(summary):
    """Export the KPI summary."""

    summary.to_csv(
        OUTPUT_FILE,
        index=False
    )

    print(f"\nKPI summary exported to:\n{OUTPUT_FILE}")


# Main

def main():

    print("Loading Coffee Shop sales data...")

    sales = load_data()

    print(f"Loaded {len(sales):,} records.")

    print("\nCalculating key performance indicators...")

    kpi_summary = calculate_kpis(sales)

    print("\nExecutive KPI Summary")
    print("-" * 40)
    print(kpi_summary)

    save_results(kpi_summary)

    print("\nKPI analysis completed successfully.")


if __name__ == "__main__":
    main()