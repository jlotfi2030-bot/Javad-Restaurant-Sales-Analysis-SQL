# Javad-Restaurant-Sales-Analysis-SQL
Description:

SQL-based analytics project involving data quality checks, dimensional modeling using a star schema, and comprehensive restaurant sales analysis to generate meaningful business KPIs and insights.

📊 Project Overview

Javad Restaurant Sales Analysis (SQL) is an end-to-end data analytics project designed to analyze restaurant and food delivery sales data using structured SQL workflows and industry-standard analytical practices.

The project begins with data cleaning and validation, ensuring data accuracy and reliability by performing null checks, identifying blank values, and detecting and removing duplicate records using SQL window functions. These steps create a trusted analytical dataset and prevent misleading insights caused by poor data quality.

Once the data is cleansed, the project applies dimensional modeling using a Star Schema, a widely adopted approach in analytics and business intelligence. This design separates descriptive attributes into dimension tables and stores measurable metrics in a central fact table, improving query performance, scalability, and reporting clarity.

On top of this analytical foundation, the project delivers business KPIs and deep-dive insights across time, location, restaurants, food categories, pricing, and customer behavior. The final result is an analytics-ready dataset that can be easily consumed by BI tools such as Power BI or Tableau.

⸻

🎯 Business Objectives
 • Ensure high-quality, analysis-ready data through systematic cleaning and validation
 • Design a scalable and efficient Star Schema for analytical reporting
 • Generate meaningful KPIs to evaluate restaurant sales performance
 • Enable time-based, location-based, and product-level insights
 • Demonstrate practical SQL skills applicable to real-world analytics roles

⸻

🧹 Data Cleaning & Validation

The raw dataset contains food delivery order records across multiple states, cities, restaurants, categories, and dishes. To ensure data integrity, the following checks are performed:

✔️ Null Checks

Missing values are identified in critical business columns:
 • State
 • City
 • Order_Date
 • Restaurant_Name
 • Location
 • Category
 • Dish_Name
 • Price_INR
 • Rating
 • Rating_Count

✔️ Blank / Empty Value Detection

Fields containing empty strings are detected and handled to avoid inaccurate aggregations.

✔️ Duplicate Detection

Duplicate records are identified by grouping across all business-critical columns.

✔️ Duplicate Removal

SQL ROW_NUMBER() window functions are used to remove surplus duplicates while retaining one clean record per unique order.

⸻

🧱 Data Modeling – Star Schema

To optimize analytics and reporting performance, the project implements a Star Schema that separates dimensions from facts.

📐 Dimension Tables
 • dim_date → Year, Month, Quarter, Week
 • dim_location → State, City, Location
 • dim_restaurant → Restaurant_Name
 • dim_category → Cuisine / Category
 • dim_dish → Dish_Name

⭐️ Fact Table
 • fact_restaurant_orders
 • Price_INR
 • Rating
 • Rating_Count
 • Foreign keys to all dimension tables

Each dimension is populated with distinct values from the cleaned dataset, and the fact table is loaded with all dimensional keys properly resolved.

⸻

📈 Key Performance Indicators (KPIs)

🔹 Core Metrics
 • Total Orders
 • Total Revenue (INR Million)
 • Average Dish Price
 • Average Rating

⸻

🔍 Analytical Insights

📅 Date-Based Analysis
 • Monthly order trends
 • Quarterly order trends
 • Year-over-year growth
 • Day-of-week ordering patterns

🌍 Location-Based Analysis
 • Top 10 cities by order volume
 • Revenue contribution by state

🍲 Food & Restaurant Performance
 • Top 10 restaurants by total orders
 • Top-performing food categories (e.g., Indian, Chinese)
 • Most ordered dishes
 • Cuisine performance based on order volume and average rating

💰 Customer Spending Behavior

Order distribution across spending buckets:
 • Under 100
 • 100–199
 • 200–299
 • 300–499
 • 500+

⭐️ Ratings Analysis
 • Distribution of dish ratings from 1 to 5
 • Relationship between rating counts and order volume

⸻

🛠️ Tools & Technologies
 • SQL (CTEs, Joins, Window Functions, Aggregations)
 • Dimensional Modeling (Star Schema)
 • Analytics-Ready Data Design
 • BI-Friendly Data Structures
