-- Customer Intelligence & Marketing Analytics
-- SQL Business Analysis Queries


-- 1. Core Business KPIs
SELECT
    COUNT("Order ID") AS delivered_orders,
    SUM("Final Bill Amount (₹)") AS total_revenue,
    AVG("Final Bill Amount (₹)") AS average_order_value
FROM orders
WHERE "Order Status" = 'Delivered';


-- 2. Top 10 Customers by Spend
SELECT
    customer_id,
    COUNT("Order ID") AS total_orders,
    SUM("Final Bill Amount (₹)") AS total_spend,
    AVG("Final Bill Amount (₹)") AS average_order_value
FROM orders
WHERE "Order Status" = 'Delivered'
GROUP BY customer_id
ORDER BY total_spend DESC
LIMIT 10;


-- 3. Revenue by Restaurant
SELECT
    "Restaurant Name" AS restaurant,
    COUNT("Order ID") AS orders,
    SUM("Final Bill Amount (₹)") AS revenue
FROM orders
WHERE "Order Status" = 'Delivered'
GROUP BY "Restaurant Name"
ORDER BY revenue DESC;


-- 4. Monthly Revenue
SELECT
    strftime('%Y-%m', "Order Date & Time") AS month,
    COUNT("Order ID") AS orders,
    SUM("Final Bill Amount (₹)") AS revenue
FROM orders
WHERE "Order Status" = 'Delivered'
GROUP BY month
ORDER BY month;


-- 5. Payment Method Analysis
SELECT
    "Payment Method" AS payment_method,
    COUNT("Order ID") AS orders,
    SUM("Final Bill Amount (₹)") AS revenue
FROM orders
WHERE "Order Status" = 'Delivered'
GROUP BY "Payment Method"
ORDER BY orders DESC;


-- 6. Orders by Hour
SELECT
    strftime('%H', "Order Date & Time") AS hour,
    COUNT("Order ID") AS orders
FROM orders
WHERE "Order Status" = 'Delivered'
GROUP BY hour
ORDER BY hour;


-- 7. Customer Frequency
SELECT
    customer_id,
    COUNT("Order ID") AS total_orders
FROM orders
WHERE "Order Status" = 'Delivered'
GROUP BY customer_id
ORDER BY total_orders DESC;