import pandas as pd
from pathlib import Path


def load_orders(file_path: str) -> pd.DataFrame:
    """Load the orders sheet from the Excel dataset."""
    orders = pd.read_excel(
        file_path,
        sheet_name="orders"
    )

    orders["Order Date & Time"] = pd.to_datetime(
        orders["Order Date & Time"]
    )

    return orders


def clean_orders(orders: pd.DataFrame) -> pd.DataFrame:
    """Basic validation and cleanup of the order dataset."""

    orders = orders.copy()

    orders = orders.drop_duplicates()

    required_columns = [
        "customer_id",
        "Order ID",
        "Order Status",
        "Final Bill Amount (₹)",
        "Order Date & Time"
    ]

    missing_columns = [
        col for col in required_columns
        if col not in orders.columns
    ]

    if missing_columns:
        raise ValueError(
            f"Missing required columns: {missing_columns}"
        )

    return orders


def get_delivered_orders(orders: pd.DataFrame) -> pd.DataFrame:
    """Return delivered orders only."""
    return orders[
        orders["Order Status"] == "Delivered"
    ].copy()


def build_customer_summary(
    delivered_orders: pd.DataFrame
) -> pd.DataFrame:
    """Create a customer-level transaction summary."""

    customer_summary = (
        delivered_orders
        .groupby("customer_id")
        .agg(
            total_orders=("Order ID", "count"),
            total_spend=("Final Bill Amount (₹)", "sum"),
            average_order_value=("Final Bill Amount (₹)", "mean"),
            last_order_date=("Order Date & Time", "max")
        )
        .reset_index()
    )

    return customer_summary


if __name__ == "__main__":

    from pathlib import Path

    BASE_DIR = Path(__file__).resolve().parent.parent

    file_path = (
        BASE_DIR
        / "data"
        / "data_raw"
        / "customer_intelligence_100_customers.xlsx"
    )

    orders = load_orders(file_path)
    orders = clean_orders(orders)
    delivered_orders = get_delivered_orders(orders)

    customer_summary = build_customer_summary(
        delivered_orders
    )

    print("Orders:", len(orders))
    print("Delivered orders:", len(delivered_orders))
    print(
        "Customers:",
        customer_summary["customer_id"].nunique()
    )