SELECT *
FROM album;

SELECT *
FROM artist;

SELECT *
FROM customer;

SELECT *
FROM employee;

SELECT *
FROM genre;

SELECT *
FROM invoice;

SELECT *
FROM invoice_line;

SELECT *
FROM media_type;

SELECT *
FROM playlist;

SELECT *
FROM playlist_track;

SELECT *
FROM track;

-------------------

-- YEAR: How many invoices were made? How many sales were made? How much revenue was made?

SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS year,
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
GROUP BY EXTRACT(YEAR FROM i.invoice_date);

WITH sub AS (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY EXTRACT(YEAR FROM i.invoice_date)
)
SELECT 
	ROUND(AVG(num_unique_invoices), 2) AS avg_invoice,
	ROUND(AVG(num_sales), 2) AS avg_sales
FROM sub;

SELECT
	EXTRACT(YEAR FROM invoice_date) AS year,
	SUM(total) AS sum_sales_total
FROM invoice
GROUP BY EXTRACT(YEAR FROM invoice_date);

WITH sub AS (
	SELECT
		EXTRACT(YEAR FROM invoice_date) AS year,
		SUM(total) AS sum_sales_total
	FROM invoice
	GROUP BY EXTRACT(YEAR FROM invoice_date)
)
SELECT ROUND(AVG(sum_sales_total), 2) AS avg_yearly_sales
FROM sub;

-- 2. For each year, what is the monthly trend in the number of unique invoices? The number of sales? The revenue?

SELECT
	EXTRACT(MONTH FROM i.invoice_date) AS month,
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
WHERE EXTRACT(YEAR FROM i.invoice_date) = 2021
GROUP BY EXTRACT(MONTH FROM i.invoice_date);

SELECT
	EXTRACT(MONTH FROM i.invoice_date) AS month,
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
WHERE EXTRACT(YEAR FROM i.invoice_date) = 2022
GROUP BY EXTRACT(MONTH FROM i.invoice_date);

SELECT
	EXTRACT(MONTH FROM i.invoice_date) AS month,
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
WHERE EXTRACT(YEAR FROM i.invoice_date) = 2023
GROUP BY EXTRACT(MONTH FROM i.invoice_date);

SELECT
	EXTRACT(MONTH FROM i.invoice_date) AS month,
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
WHERE EXTRACT(YEAR FROM i.invoice_date) = 2024
GROUP BY EXTRACT(MONTH FROM i.invoice_date);

SELECT
	EXTRACT(MONTH FROM i.invoice_date) AS month,
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
WHERE EXTRACT(YEAR FROM i.invoice_date) = 2025
GROUP BY EXTRACT(MONTH FROM i.invoice_date);

-- 2. For each year, what is the quarterly trend in the number of unique invoices? The number of sales? The revenue?

SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS year,
	EXTRACT(QUARTER FROM i.invoice_date) AS quarter,
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales,
	SUM(il.quantity * il.unit_price) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
GROUP BY 
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(QUARTER FROM i.invoice_date)
ORDER BY
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(QUARTER FROM i.invoice_date);

WITH sub as (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		EXTRACT(QUARTER FROM i.invoice_date) AS quarter,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales,
		SUM(il.quantity * il.unit_price) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY 
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(QUARTER FROM i.invoice_date)
	ORDER BY
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(QUARTER FROM i.invoice_date)
)
SELECT
	ROUND(AVG(num_unique_invoices)) AS avg_invoices,
	ROUND(AVG(num_sales)) AS avg_sales,
	ROUND(AVG(revenue), 2) AS avg_revenue,
	ROUND(SUM(revenue), 2) AS sum_revenue,
	MAX(revenue) AS max_revenue,
	MIN(revenue) AS min_revenue
FROM sub;

-- 3. For each year, what is the monthly trend in the number of unique invoices? The number of sales? The revenue?

SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS year,
	EXTRACT(MONTH FROM i.invoice_date) AS month,
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales,
	SUM(il.quantity * il.unit_price) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
GROUP BY 
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(MONTH FROM i.invoice_date)
ORDER BY
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(MONTH FROM i.invoice_date);

WITH sub AS (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		EXTRACT(MONTH FROM i.invoice_date) AS month,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales,
		SUM(il.quantity * il.unit_price) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY 
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(MONTH FROM i.invoice_date)
	ORDER BY
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(MONTH FROM i.invoice_date)
)
SELECT AVG(revenue)
FROM sub;

-- 4. What is the quarterly trend in the number of sales and the revenue?

WITH sub as (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		EXTRACT(QUARTER FROM i.invoice_date) AS quarter,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales,
		SUM(il.quantity * il.unit_price) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY 
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(QUARTER FROM i.invoice_date)
	ORDER BY
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(QUARTER FROM i.invoice_date)
)
SELECT
	ROUND(AVG(num_unique_invoices)) AS avg_invoices,
	MAX(num_unique_invoices) AS max_invoices,
	MIN(num_unique_invoices) AS min_invoices,
	ROUND(AVG(num_sales)) AS avg_sales,
	MAX(num_sales) AS max_sales,
	MIN(num_sales) AS min_sales,
	ROUND(AVG(revenue), 2) AS avg_revenue,
	MAX(revenue) AS max_revenue,
	MIN(revenue) AS min_revenue
FROM sub;

WITH sub as (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		EXTRACT(QUARTER FROM i.invoice_date) AS quarter,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales,
		SUM(il.quantity * il.unit_price) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY 
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(QUARTER FROM i.invoice_date)
	ORDER BY
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(QUARTER FROM i.invoice_date)
)
SELECT
	quarter AS "Quarter",
	ROUND(AVG(num_unique_invoices)) AS "Average Number of Invoices",
	ROUND(AVG(num_sales)) AS "Average Number of Sales",
	ROUND(AVG(revenue), 2) AS "Average Revenue"
FROM sub
GROUP BY quarter
ORDER BY quarter;


WITH sub as (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		EXTRACT(QUARTER FROM i.invoice_date) AS quarter,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales,
		SUM(il.quantity * il.unit_price) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY 
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(QUARTER FROM i.invoice_date)
	ORDER BY
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(QUARTER FROM i.invoice_date)
),
sub2 AS (
	SELECT
		quarter AS "Quarter",
		ROUND(AVG(num_unique_invoices)) AS "Average Number of Invoices",
		ROUND(AVG(num_sales)) AS "Average Number of Sales",
		ROUND(AVG(revenue), 2) AS "Average Revenue"
	FROM sub
	GROUP BY quarter
	ORDER BY quarter
)
SELECT
	"Quarter",
	"Average Revenue" / (
		SELECT AVG(revenue)
		FROM sub
	) AS "Seasonality Index"
FROM sub2;


-- 5. What is the monthly trend in the number of sales and the revenue?

WITH sub as (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		EXTRACT(MONTH FROM i.invoice_date) AS month,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales,
		SUM(il.quantity * il.unit_price) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY 
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(MONTH FROM i.invoice_date)
	ORDER BY
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(MONTH FROM i.invoice_date)
)
SELECT
	ROUND(AVG(num_unique_invoices)) AS avg_invoices,
	MAX(num_unique_invoices) AS max_invoices,
	MIN(num_unique_invoices) AS min_invoices,
	ROUND(AVG(num_sales)) AS avg_sales,
	MAX(num_sales) AS max_sales,
	MIN(num_sales) AS min_sales,
	ROUND(AVG(revenue), 2) AS avg_revenue,
	MAX(revenue) AS max_revenue,
	MIN(revenue) AS min_revenue
FROM sub;

WITH sub as (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		EXTRACT(MONTH FROM i.invoice_date) AS month,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales,
		SUM(il.quantity * il.unit_price) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY 
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(MONTH FROM i.invoice_date)
	ORDER BY
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(MONTH FROM i.invoice_date)
)
SELECT
	month AS "Month",
	ROUND(AVG(num_unique_invoices)) AS "Average Number of Invoices",
	ROUND(AVG(num_sales)) AS "Average Number of Sales",
	ROUND(AVG(revenue), 2) AS "Average Revenue"
FROM sub
GROUP BY month
ORDER BY month;


WITH sub as (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		EXTRACT(MONTH FROM i.invoice_date) AS month,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales,
		SUM(il.quantity * il.unit_price) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY 
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(MONTH FROM i.invoice_date)
	ORDER BY
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(MONTH FROM i.invoice_date)
),
sub2 AS (
	SELECT
		month AS "Month",
		ROUND(AVG(num_unique_invoices)) AS "Average Number of Invoices",
		ROUND(AVG(num_sales)) AS "Average Number of Sales",
		ROUND(AVG(revenue), 2) AS "Average Revenue"
	FROM sub
	GROUP BY month
	ORDER BY month
)
SELECT
	"Month",
	"Average Revenue" / (
		SELECT AVG(revenue)
		FROM sub
	) AS "Seasonality Index"
FROM sub2;
