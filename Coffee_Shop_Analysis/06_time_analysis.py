"""
Coffee Shop Analytics Project

Script: 06_time_analysis.py

Purpose:
Analyze sales trends by hour, day of the week, month,
and day type (weekday vs. weekend). Export summary
tables for reporting and Power BI.

Author:
Collin Quaintance
"""

from pathlib import Path
import pandas as pd

# Configuration

CSV_FILE = Path("../outputs/clean_sales.csv")

OUTPUT_DIR = Path("../outputs")
OUTPUT_DIR.mkdir(exist_ok=True)

HOURLY_OUTPUT = OUTPUT_DIR / "hourly_summary.csv"
DAILY_OUTPUT = OUTPUT_DIR / "daily_summary.csv"
MONTHLY_OUTPUT = OUTPUT_DIR / "monthly_summary.csv"
DAYTYPE_OUTPUT = OUTPUT_DIR / "daytype_summary.csv"

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


# Hourly Analysis

def hourly_summary(df):
    """Summarize sales performance by hour."""

    summary = (
        df.groupby("hour")
        .agg(
            total_revenue=("revenue", "sum"),
            total_transactions=("transaction_id", "count"),
            units_sold=("transaction_qty", "sum"),
            average_order_value=("revenue", "mean")
        )
        .reset_index()
        .sort_values("hour")
    )

    return summary


# Daily Analysis

def daily_summary(df):
    """Summarize sales by day of the week."""

    day_order = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
    ]

    summary = (
        df.groupby("day_name")
        .agg(
            total_revenue=("revenue", "sum"),
            total_transactions=("transaction_id", "count"),
            units_sold=("transaction_qty", "sum")
        )
        .reindex(day_order)
        .reset_index()
    )

    return summary


# Monthly Analysis

def monthly_summary(df):
    """Summarize sales by month."""

    month_order = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ]

    summary = (
        df.groupby("month")
        .agg(
            total_revenue=("revenue", "sum"),
            total_transactions=("transaction_id", "count"),
            units_sold=("transaction_qty", "sum")
        )
        .reindex(month_order)
        .dropna()
        .reset_index()
    )

    return summary


# Weekday vs. Weekend Analysis

def daytype_summary(df):
    """Compare weekday and weekend sales."""

    summary = (
        df.groupby("day_type")
        .agg(
            total_revenue=("revenue", "sum"),
            total_transactions=("transaction_id", "count"),
            units_sold=("transaction_qty", "sum")
        )
        .reset_index()
    )

    summary["revenue_share"] = (
        summary["total_revenue"]
        / summary["total_revenue"].sum()
        * 100
    ).round(2)

    return summary


# Export Results

def export_results(
    hourly,
    daily,
    monthly,
    daytype
):
    """Export all time-based summaries."""

    hourly.to_csv(
        HOURLY_OUTPUT,
        index=False
    )

    daily.to_csv(
        DAILY_OUTPUT,
        index=False
    )

    monthly.to_csv(
        MONTHLY_OUTPUT,
        index=False
    )

    daytype.to_csv(
        DAYTYPE_OUTPUT,
        index=False
    )

    print("\nAnalysis files exported:")
    print(f"• {HOURLY_OUTPUT.name}")
    print(f"• {DAILY_OUTPUT.name}")
    print(f"• {MONTHLY_OUTPUT.name}")
    print(f"• {DAYTYPE_OUTPUT.name}")


# Main

def main():

    print("Loading cleaned sales data...")

    sales = load_data()

    print(f"Loaded {len(sales):,} sales records.")

    print("\nAnalyzing sales trends over time...")

    hourly = hourly_summary(sales)
    daily = daily_summary(sales)
    monthly = monthly_summary(sales)
    daytype = daytype_summary(sales)

    export_results(
        hourly,
        daily,
        monthly,
        daytype
    )

    print("\nHourly Summary")
    print("-" * 40)
    print(hourly.head())

    print("\nDaily Summary")
    print("-" * 40)
    print(daily)

    print("\nMonthly Summary")
    print("-" * 40)
    print(monthly)

    print("\nWeekday vs. Weekend")
    print("-" * 40)
    print(daytype)

    print("\nTime analysis completed successfully.")


if __name__ == "__main__":
    main()