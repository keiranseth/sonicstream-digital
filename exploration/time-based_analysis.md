# Time-based Analysis

## Tables of Contents

- [Time-based Analysis](#time-based-analysis)
	- [Tables of Contents](#tables-of-contents)
	- [Questions](#questions)
		- [1. What is the yearly trend in the number of unique invoices? The number of sales? The revenue?](#1-what-is-the-yearly-trend-in-the-number-of-unique-invoices-the-number-of-sales-the-revenue)
		- [2. For each year, what is the quarterly trend in the number of unique invoices? The number of sales? The revenue?](#2-for-each-year-what-is-the-quarterly-trend-in-the-number-of-unique-invoices-the-number-of-sales-the-revenue)
		- [3. For each year, what is the monthly trend in the number of unique invoices? The number of sales? The revenue?](#3-for-each-year-what-is-the-monthly-trend-in-the-number-of-unique-invoices-the-number-of-sales-the-revenue)
		- [4. What is the quarterly trend in the number of sales and the revenue?](#4-what-is-the-quarterly-trend-in-the-number-of-sales-and-the-revenue)
		- [5. What is the monthly trend in the number of sales and the revenue?](#5-what-is-the-monthly-trend-in-the-number-of-sales-and-the-revenue)
		- [6. What is the trend within the usual day of week?](#6-what-is-the-trend-within-the-usual-day-of-week)

## Questions

The answer to these questions must differentiate between 2024 and the first half of 2025.

### 1. What is the yearly trend in the number of unique invoices? The number of sales? The revenue?

```sql
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
```

```sql
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
```

### 2. For each year, what is the quarterly trend in the number of unique invoices? The number of sales? The revenue?

```sql
SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS year,
	EXTRACT(QUARTER FROM i.invoice_date) AS quarter,
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
GROUP BY
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(QUARTER FROM i.invoice_date)
ORDER BY
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(QUARTER FROM i.invoice_date);
```

```sql
WITH sub as (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		EXTRACT(QUARTER FROM i.invoice_date) AS quarter,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales,
		SUM(i.total) AS revenue
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
	MAX(revenue) AS max_revenue,
	MIN(revenue) AS min_revenue
FROM sub;
```

### 3. For each year, what is the monthly trend in the number of unique invoices? The number of sales? The revenue?

```sql
SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS year,
	EXTRACT(MONTH FROM i.invoice_date) AS month,
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
GROUP BY
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(MONTH FROM i.invoice_date);
```

### 4. What is the quarterly trend in the number of sales and the revenue?

```sql
WITH sub as (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		EXTRACT(QUARTER FROM i.invoice_date) AS quarter,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales,
		SUM(i.total) AS revenue
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
		SUM(i.total) AS revenue
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
```

### 5. What is the monthly trend in the number of sales and the revenue?

```sql
WITH sub as (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		EXTRACT(MONTH FROM i.invoice_date) AS month,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales,
		SUM(i.total) AS revenue
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
		SUM(i.total) AS revenue
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
```

### 6. What is the trend within the usual day of week?

```sql
SELECT
	EXTRACT(DOW FROM i.invoice_date) AS "Day of Week",
	ROUND(AVG(DISTINCT il.invoice_id)) AS "Number of Unique Invoices",
	ROUND(AVG(DISTINCT il.invoice_line_id)) AS "Number of Sales",
	ROUND(AVG(i.total), 2) AS "Revenue"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
GROUP BY EXTRACT(DOW FROM i.invoice_date)
ORDER BY EXTRACT(DOW FROM i.invoice_date);
```

```sql
WITH sub AS (
	SELECT
		EXTRACT(DOW FROM i.invoice_date) AS dow,
		ROUND(AVG(DISTINCT il.invoice_id)) AS num_invoices,
		ROUND(AVG(DISTINCT il.invoice_line_id)) AS num_sales,
		ROUND(AVG(i.total), 2) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY EXTRACT(DOW FROM i.invoice_date)
	ORDER BY EXTRACT(DOW FROM i.invoice_date)
)
SELECT
	ROUND(AVG(num_invoices)),
	ROUND(AVG(num_sales)),
	ROUND(AVG(revenue), 2)
FROM sub;
```
