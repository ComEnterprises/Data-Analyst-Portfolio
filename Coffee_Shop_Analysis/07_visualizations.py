"""
Coffee Shop Analytics Project

Script: 07_visualizations.py

Purpose:
Create charts that summarize sales performance across
stores, products, and time. The charts are saved as
image files for reports, presentations, and GitHub.

Author:
Collin Quaintance
"""

from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

# Configuration

CSV_FILE = Path("../outputs/clean_sales.csv")

IMAGE_DIR = Path("../images")
IMAGE_DIR.mkdir(exist_ok=True)

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


# Revenue by Store

def revenue_by_store(df):
    """Create a bar chart showing revenue by store."""

    summary = (
        df.groupby("store_location")["revenue"]
        .sum()
        .sort_values(ascending=False)
    )

    plt.figure(figsize=(8, 5))

    summary.plot(kind="bar")

    plt.title("Revenue by Store")
    plt.xlabel("Store")
    plt.ylabel("Revenue ($)")

    plt.tight_layout()

    plt.savefig(
        IMAGE_DIR / "revenue_by_store.png",
        dpi=300
    )

    plt.close()


# Revenue by Category

def revenue_by_category(df):
    """Create a pie chart showing revenue by category."""

    summary = (
        df.groupby("product_category")["revenue"]
        .sum()
    )

    plt.figure(figsize=(8, 8))

    summary.plot(
        kind="pie",
        autopct="%1.1f%%"
    )

    plt.ylabel("")
    plt.title("Revenue by Product Category")

    plt.tight_layout()

    plt.savefig(
        IMAGE_DIR / "revenue_by_category.png",
        dpi=300
    )

    plt.close()


# Revenue by Hour

def revenue_by_hour(df):
    """Create a line chart showing hourly revenue."""

    summary = (
        df.groupby("hour")["revenue"]
        .sum()
    )

    plt.figure(figsize=(10, 5))

    summary.plot(
        kind="line",
        marker="o"
    )

    plt.title("Revenue by Hour")
    plt.xlabel("Hour")
    plt.ylabel("Revenue ($)")

    plt.grid(True)

    plt.tight_layout()

    plt.savefig(
        IMAGE_DIR / "revenue_by_hour.png",
        dpi=300
    )

    plt.close()


# Revenue by Month

def revenue_by_month(df):
    """Create a bar chart showing monthly revenue."""

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
        df.groupby("month")["revenue"]
        .sum()
        .reindex(month_order)
        .dropna()
    )

    plt.figure(figsize=(10, 5))

    summary.plot(kind="bar")

    plt.title("Revenue by Month")
    plt.xlabel("Month")
    plt.ylabel("Revenue ($)")

    plt.tight_layout()

    plt.savefig(
        IMAGE_DIR / "revenue_by_month.png",
        dpi=300
    )

    plt.close()


# Top Products

def top_products(df):
    """Create a chart of the top-selling products."""

    summary = (
        df.groupby("product_detail")["revenue"]
        .sum()
        .sort_values(ascending=False)
        .head(10)
    )

    plt.figure(figsize=(10, 6))

    summary.sort_values().plot(kind="barh")

    plt.title("Top 10 Products")
    plt.xlabel("Revenue ($)")

    plt.tight_layout()

    plt.savefig(
        IMAGE_DIR / "top_products.png",
        dpi=300
    )

    plt.close()


# Main

def main():

    print("Loading cleaned sales data...")

    sales = load_data()

    print(f"Loaded {len(sales):,} sales records.")

    print("\nCreating visualizations...")

    revenue_by_store(sales)
    revenue_by_category(sales)
    revenue_by_hour(sales)
    revenue_by_month(sales)
    top_products(sales)

    print("\nCharts created successfully:")
    print("• revenue_by_store.png")
    print("• revenue_by_category.png")
    print("• revenue_by_hour.png")
    print("• revenue_by_month.png")
    print("• top_products.png")

    print(f"\nSaved to: {IMAGE_DIR.resolve()}")

    print("\nVisualization script completed successfully.")


if __name__ == "__main__":
    main()