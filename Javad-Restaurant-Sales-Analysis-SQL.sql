/********************************************************************
-- Project: Javad Restaurant Sales Analysis (SQL)
-- Section 1: 01_data_cleaning
-- Author: Javad Lotfi
-- Purpose: Data cleaning and validation for restaurant sales dataset
-- Description: This script performs null checks, removes duplicates, 
--              and prepares data for dimensional modeling.
********************************************************************/
select * from [Javad's Store 1_Data]

--Data Validation & Cleanig 
--null chek
select 
	SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) as null_state,
	SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) as null_city,
	SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) as null_order_date,
	SUM(CASE WHEN Restaurant_Name IS NULL THEN 1 ELSE 0 END) as null_restaurant,
	SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) as null_location,
	SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) as null_categorye,
	SUM(CASE WHEN Dish_Name IS NULL THEN 1 ELSE 0 END) as null_dish,
	SUM(CASE WHEN Price_INR IS NULL THEN 1 ELSE 0 END) as null_price,
	SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) as null_rating,
	SUM(CASE WHEN Rating_Count IS NULL THEN 1 ELSE 0 END) as null_rating_count
FROM [Javad's Store 1_Data];

--Blank or Empty Strings
select *
FROM [Javad's Store 1_Data]
WHERE
State =' ' OR City=' ' OR Restaurant_Name = ' ' OR Location = ' ' OR Category = ' ' OR Dish_Name = ' ' 

--Duplication Detection
SELECt
State, City, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count,COUNT(*) as CNT
FROM [Javad's Store 1_Data]
GROUP BY
State, City, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count
HAVING COUNT(*)>1

--Delete Duplication
WITH CTE AS (
Select *, ROW_NUMBER() Over(
		PARTITION BY State, City, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count
ORDER BY (SELECT NULL)
 ) AS rn
 FROM [Javad's Store 1_Data]
 )
 DELETE FROM CTE WHERE rn>1

 /********************************************************************
-- Project: Javad Restaurant Sales Analysis (SQL)
-- Section 1: 02_dimensions
-- Author: Javad Lotfi
-- Purpose: Create dimension tables for Star Schema
-- Description: 
--   - dim_date, dim_location, dim_restaurant, dim_category, dim_dish
--   - Populate dimensions with distinct values from cleaned dataset
********************************************************************/
 --CREATING SCHEMA
 --DIMENSION TABELES
 --DATE TABLE
 CREATE TABLE dim_date (
	date_id INT IDENTITY(1,1) PRIMARY KEY,
	Full_Date DATE,
	Year INT,
	Month INT,
	Month_Name varchar(20),
	Quater INT,
	Day INT,
	Week INT
	)


--DIM LOCATION
CREATE TABLE dim_location (
	location_id INT IDENTITY(1,1) PRIMARY KEY,
	State VARCHAR(100),
	City VARCHAR(100),
	Location VARCHAR(200)
);


---DIM RESTAURANT
CREATE TABLE dim_restaurant (
	restaurant_id INT IDENTITY (1,1) PRIMARY KEY,
	Restaurant_Name VARCHAR(200)
);


--DIM CATEGORY
CREATE TABLE dim_category (
	category_id INT IDENTITY (1,1) PRIMARY KEY,
	Category VARCHAR(200)
);


--DIM DISH
CREATE TABLE dim_dish (
	dish_id INT IDENTITY (1,1) PRIMARY KEY,
	Dish_Name VARCHAR(200)
);



--FACT TABLE
CREATE TABLE fact_javad_orders (
	order_id INT IDENTITY (1,1) PRIMARY KEY,

	date_id INT,
	Price_INR DECIMAL(10,2),
	Rating DECIMAL(4,2),
	Rating_count INT,

	location_id INT,
	restaurant_id INT,
	category_id INT,
	dish_id INT,

	FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
	FOREIGN KEY (location_id) REFERENCES dim_location(location_id),
	FOREIGN KEY (restaurant_id) REFERENCES dim_restaurant(restaurant_id),
	FOREIGN KEY (category_id) REFERENCES dim_category(category_id),
	FOREIGN KEY (dish_id) REFERENCES dim_dish(dish_id)
);

select * from fact_javad_orders

/********************************************************************
-- Project: Javad Restaurant Sales Analysis (SQL)
-- SEction 3: 03_fact_table
-- Author: Javad Lotfi
-- Purpose: Create fact table for Star Schema
-- Description: 
--   - Combine cleaned data with dimension keys
--   - Store measurable metrics: Price_INR, Rating, Rating_Count
********************************************************************/

--INSERT DATA IN TABLES
--DIM DATE
INSERT INTO dim_date (Full_Date, Year, Month, Month_Name, Quater, Day, Week)
SELECT DISTINCT
	Order_Date,
	YEAR(Order_Date),
	MONTH(Order_Date),
	DATENAME(MONTH, Order_Date),
	DATEPART(QUARTER, Order_Date),
	DAY(Order_Date),
	DATEPART(WEEK, Order_Date)
FROM [Javad's Store 1_Data]
WHERE Order_Date IS NOT NULL;

SELECT * FROM dim_date


--DIM LOCATION
INSERT INTO dim_location (State,City, Location)
SELECT DISTINCT
	State,
	City,
	Location
FROM [Javad's Store 1_Data];

SELECT * FROM dim_location;


--DIM RESTAURANT
INSERT INTO dim_restaurant(Restaurant_Name)
SELECT DISTINCT
	Restaurant_Name
FROM [Javad's Store 1_Data];
SELECT * FROM dim_restaurant;


--DIM CATEGORY
INSERT INTO dim_category(Category)
SELECT DISTINCT 
	Category
FROM [Javad's Store 1_Data];
SELECT * FROM dim_category


--DIM DISH
INSERT INTO dim_dish(Dish_Name)
SELECT DISTINCT 
	Dish_Name
FROM [Javad's Store 1_Data];

SELECT * FROM dim_dish


--FACT TABLE 
INSERT INTO fact_javad_orders
(
	date_id,
	Price_INR,
	Rating,
	Rating_count,
	location_id,
	restaurant_id,
	category_id,
	dish_id
)
SELECT
	dd.date_id,
	s.Price_INR,
	s.Rating,
	s.Rating_Count,

	dl.location_id,
	dr.restaurant_id,
	dc.category_id,
	dsh.dish_id
FROM [Javad's Store 1_Data] s

JOIN dim_date dd
	ON dd.Full_Date = s.Order_Date

JOIN dim_location dl
	ON dl.State = s.State
	and dl.City = s.City
	and dl.Location = s.Location

JOIN dim_restaurant dr
	ON dr.Restaurant_Name = s.Restaurant_Name

JOIN dim_category dc
	ON DC.Category = S.Category

JOIN dim_dish dsh
	ON dsh.Dish_Name = s.Dish_Name;

SELECT * FROM fact_javad_orders


SELECT * FROM fact_javad_orders F
JOIN dim_date d ON f.date_id = d.date_id
JOIN dim_location l ON f.location_id = l.location_id
JOIN dim_restaurant r ON f.restaurant_id = r.restaurant_id
JOIN dim_category c ON f.category_id = c.category_id
JOIN dim_dish di ON f.dish_id = di.dish_id;


/********************************************************************
-- Project: Javad Restaurant Sales Analysis (SQL)
-- Section 4: 04_kpi_analysis
-- Author: Javad Lotfi
-- Purpose: Compute KPIs and business insights
-- Description: 
--   - Total Orders
--   - Total Revenue
--   - Average Dish Price
--   - Average Rating
--   - Location-based, time-based, and food performance analysis
********************************************************************/

--KPI'S
-- Total Orders
SELECT COUNT(*) AS Total_Orders
FROM fact_javad_orders


-- Total Revenue (INR Million)
SELECT
FORMAT(SUM(CONVERT(float,price_INR))/100000, 'N2') + ' INR Million'
AS Total_Revenue
FROM fact_javad_orders


--Average Dish Price
SELECT
FORMAT(AVG(CONVERT(float,price_INR)), 'N2') + ' INR'
AS Average_Dish_Price
FROM fact_javad_orders


--Average Rating
SELECT
AVG(Rating) AS Avg_Rating
FROM fact_javad_orders


--Deep-Dive Business Analysis

--Monthly Order Trends
--Total Orders 

SELECT
d.year,
d.month,
d.month_name,
count(*) AS Total_Orders 
FROM fact_javad_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year,
d.month,
d.month_name
ORDER BY count(*) DESC


--Total Revenue 

SELECT
d.year,
d.month,
d.month_name,
SUM(Price_INR) AS Total_Revenue 
FROM fact_javad_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year,
d.month,
d.month_name
ORDER BY SUM(Price_INR) DESC


--Quarterly Trend

SELECT
d.year,
d.Quater,
count(*) AS Total_Orders 
FROM fact_javad_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year,
d.Quater
ORDER BY count(*) DESC


--Yearly Trend
SELECT
d.year,
count(*) AS Total_Orders 
FROM fact_javad_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year
ORDER BY count(*) DESC


--Order by Day of Week (Mon-Sun)
SELECT
	DATENAME(WEEKDAY, d.full_date) AS day_name,
	COUNT(*) AS total_order
FROM fact_javad_orders F
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY DATENAME(WEEKDAY, d.full_date), DATEPART(WEEKDAY, d.full_date)
ORDER BY DATEPART(WEEKDAY, d.full_date);


--Top 10 cities by order volume
SELECT TOP 10
l.city,
COUNT(*) AS Total_ORders 
FROM fact_javad_orders f
JOIN dim_location l
ON l.location_id= F.location_id
GROUP BY l.City
ORDER BY COUNT(*) DESC;


SELECT TOP 10
l.city,
SUM(f.price_INR) AS Total_Revenue 
FROM fact_javad_orders f
JOIN dim_location l
ON l.location_id= F.location_id
GROUP BY l.City
ORDER BY SUM(f.price_INR) DESC;


--Revenue contribution by states 
SELECT 
l.State,
SUM(f.price_INR) AS Total_Revenue 
FROM fact_javad_orders f
JOIN dim_location l
ON l.location_id= F.location_id
GROUP BY l.State
ORDER BY SUM(f.price_INR) DESC;


--Top 10 restaurant by orders
SELECT TOP 10
r.Restaurant_Name,
SUM(f.price_INR) AS Total_Revenue 
FROM fact_javad_orders f
JOIN dim_restaurant r
ON r.restaurant_id = F.restaurant_id
GROUP BY r.Restaurant_Name
ORDER BY SUM(f.price_INR) DESC;


--Top Categories by Order Volume
SELECT
	c.category,
	COUNT(*) AS Total_orders
FROM fact_javad_orders f
JOIN dim_category c 
on f.category_id = c.category_id
GROUP BY c.Category
ORDER BY Total_orders DESC;


--Most Ordered Dishes
SELECT TOP 10
	d.dish_name,
	COUNT(*) AS order_count
FROM fact_javad_orders f
JOIN dim_dish d ON f.dish_id= f.dish_id
GROUP BY d.Dish_Name
ORDER BY order_count DESC;


--Cuisine Performance (Order + Avg Rating)
SELECT
	c.category,
	COUNT(*) AS total_orders,
	AVG(f.rating) AS avg_rating
FROM fact_javad_orders f
JOIN dim_category c ON f.category_id = c.category_id
GROUP BY c.Category
ORDER BY total_orders DESC;



--Total Orders by Price Range
SELECT
	CASE
		WHEN CONVERT(float, price_inr) < 100 THEN	'Under 100'
		WHEN CONVERT(float, price_inr) BETWEEN 100 AND 199 THEN	'100-199'
		WHEN CONVERT(float, price_inr) BETWEEN 200 AND 299 THEN	'200-299'
		WHEN CONVERT(float, price_inr) BETWEEN 300 AND 399 THEN	'300-399'
		ELSE '500+'
	END AS price_range,
	COUNT(*) AS total_orders
FROM fact_javad_orders
GROUP BY 
	CASE
		WHEN CONVERT(float, price_inr) < 100 THEN	'Under 100'
		WHEN CONVERT(float, price_inr) BETWEEN 100 AND 199 THEN	'100-199'
		WHEN CONVERT(float, price_inr) BETWEEN 200 AND 299 THEN	'200-299'
		WHEN CONVERT(float, price_inr) BETWEEN 300 AND 399 THEN	'300-399'
		ELSE '500+'
	END
ORDER BY total_orders DESC;


--Rating Count Distribution (1-5)
SELECT 
	rating,
	COUNT(*) AS rating_count
FROM fact_javad_orders
GROUP BY Rating
ORDER BY COUNT(*) DESC;