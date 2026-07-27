"""
Coffee Shop Analytics Project

Script: 05_product_analysis.py

Purpose:
Analyze product, product category, and product type
performance. Export summary tables that can be used
for reporting and Power BI visualizations.

Author:
Collin Quaintance
"""

from pathlib import Path
import pandas as pd

# Configuration

CSV_FILE = Path("../outputs/clean_sales.csv")

OUTPUT_DIR = Path("../outputs")
OUTPUT_DIR.mkdir(exist_ok=True)

CATEGORY_OUTPUT = OUTPUT_DIR / "category_summary.csv"
TYPE_OUTPUT = OUTPUT_DIR / "product_type_summary.csv"
PRODUCT_OUTPUT = OUTPUT_DIR / "product_summary.csv"
TOP10_OUTPUT = OUTPUT_DIR / "top_10_products.csv"
BOTTOM10_OUTPUT = OUTPUT_DIR / "bottom_10_products.csv"

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


# Category Analysis

def category_summary(df):
    """Summarize sales by product category."""

    summary = (
        df.groupby("product_category")
        .agg(
            total_revenue=("revenue", "sum"),
            total_transactions=("transaction_id", "count"),
            units_sold=("transaction_qty", "sum"),
            average_order_value=("revenue", "mean")
        )
        .reset_index()
        .sort_values(
            by="total_revenue",
            ascending=False
        )
    )

    summary["revenue_share"] = (
        summary["total_revenue"]
        / summary["total_revenue"].sum()
        * 100
    ).round(2)

    return summary


# Product Type Analysis

def product_type_summary(df):
    """Summarize sales by product type."""

    summary = (
        df.groupby("product_type")
        .agg(
            total_revenue=("revenue", "sum"),
            total_transactions=("transaction_id", "count"),
            units_sold=("transaction_qty", "sum")
        )
        .reset_index()
        .sort_values(
            by="total_revenue",
            ascending=False
        )
    )

    return summary


# Product Analysis

def product_summary(df):
    """Summarize sales for individual products."""

    summary = (
        df.groupby("product_detail")
        .agg(
            category=("product_category", "first"),
            total_revenue=("revenue", "sum"),
            total_transactions=("transaction_id", "count"),
            units_sold=("transaction_qty", "sum"),
            average_price=("unit_price", "mean")
        )
        .reset_index()
        .sort_values(
            by="total_revenue",
            ascending=False
        )
    )

    summary["revenue_rank"] = (
        summary["total_revenue"]
        .rank(
            method="dense",
            ascending=False
        )
        .astype(int)
    )

    summary["revenue_share"] = (
        summary["total_revenue"]
        / summary["total_revenue"].sum()
        * 100
    ).round(2)

    return summary


# Pareto Analysis

def pareto_analysis(summary):
    """Calculate cumulative revenue for Pareto analysis."""

    summary = summary.copy()

    summary["cumulative_revenue"] = (
        summary["total_revenue"].cumsum()
    )

    summary["cumulative_percent"] = (
        summary["cumulative_revenue"]
        / summary["total_revenue"].sum()
        * 100
    ).round(2)

    return summary


# Export Results

def export_results(
    category,
    product_type,
    product,
    top10,
    bottom10
):
    """Export all analysis tables."""

    category.to_csv(
        CATEGORY_OUTPUT,
        index=False
    )

    product_type.to_csv(
        TYPE_OUTPUT,
        index=False
    )

    product.to_csv(
        PRODUCT_OUTPUT,
        index=False
    )

    top10.to_csv(
        TOP10_OUTPUT,
        index=False
    )

    bottom10.to_csv(
        BOTTOM10_OUTPUT,
        index=False
    )

    print("\nAnalysis files exported:")
    print(f"• {CATEGORY_OUTPUT.name}")
    print(f"• {TYPE_OUTPUT.name}")
    print(f"• {PRODUCT_OUTPUT.name}")
    print(f"• {TOP10_OUTPUT.name}")
    print(f"• {BOTTOM10_OUTPUT.name}")


# Main

def main():

    print("Loading cleaned sales data...")

    sales = load_data()

    print(f"Loaded {len(sales):,} sales records.")

    print("\nAnalyzing product performance...")

    category = category_summary(sales)

    product_types = product_type_summary(sales)

    products = product_summary(sales)

    products = pareto_analysis(products)

    top10 = products.head(10)

    bottom10 = products.tail(10)

    export_results(
        category,
        product_types,
        products,
        top10,
        bottom10
    )

    print("\nTop 10 Products")
    print("-" * 40)
    print(top10)

    print("\nProduct analysis completed successfully.")


if __name__ == "__main__":
    main()