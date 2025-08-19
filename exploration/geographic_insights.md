# Geographic Insights

## Table of Contents

- [Geographic Insights](#geographic-insights)
  - [Table of Contents](#table-of-contents)
  - [Questions](#questions)
    - [1. What is the average and median number of sales per country?](#1-what-is-the-average-and-median-number-of-sales-per-country)
    - [2. What are the top 10 countries by the number of sales?](#2-what-are-the-top-10-countries-by-the-number-of-sales)
    - [3. What is the average and median number of invoices per country?](#3-what-is-the-average-and-median-number-of-invoices-per-country)
    - [4. What are the top 10 countries by the number of invoices?](#4-what-are-the-top-10-countries-by-the-number-of-invoices)
    - [5. What is the average and median revenue per country?](#5-what-is-the-average-and-median-revenue-per-country)
    - [6. What are the top-10 countries by revenue?](#6-what-are-the-top-10-countries-by-revenue)
    - [7. Is there any correlation between the number of customers and the revenue by country? Are there countries with high customer count and low revenue?](#7-is-there-any-correlation-between-the-number-of-customers-and-the-revenue-by-country-are-there-countries-with-high-customer-count-and-low-revenue)

## Questions

### 1. What is the average and median number of sales per country?

```sql
SELECT
	c.country,
	COUNT(DISTINCT i.invoice_id) AS num_invoices,
	COUNT(il.invoice_line_id) AS num_sales1,
	SUM(il.quantity) AS num_sales2,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.country;

WITH sub AS (
	SELECT
		c.country,
		COUNT(DISTINCT i.invoice_id) AS num_invoices,
		COUNT(il.invoice_line_id) AS num_sales1,
		SUM(il.quantity) AS num_sales2,
		SUM(i.total) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	INNER JOIN track AS t
		ON il.track_id = t.track_id
	INNER JOIN customer AS c
		ON i.customer_id = c.customer_id
	GROUP BY c.country
)
SELECT
	ROUND(AVG(num_sales1)) AS "Average Number of Sales Per Country",
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY num_sales1) AS "Median Number of Sales Per Country",
	ROUND(AVG(num_sales2)) AS "Average Number of Sales Per Country",
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY num_sales2) AS "Median Number of Sales Per Country"
FROM sub;
```

### 2. What are the top 10 countries by the number of sales?

```sql
SELECT
	c.country AS "Country",
	COUNT(il.invoice_line_id) AS "Number of Sales",
	SUM(il.quantity) AS "Number of Sales2"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.country
ORDER BY "Number of Sales" DESC
LIMIT 10;
```

### 3. What is the average and median number of invoices per country?

```sql
SELECT
	c.country,
	COUNT(DISTINCT i.invoice_id) AS num_invoices,
	COUNT(il.invoice_line_id) AS num_sales1,
	SUM(il.quantity) AS num_sales2,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.country;

WITH sub AS (
	SELECT
		c.country,
		COUNT(DISTINCT i.invoice_id) AS num_invoices,
		COUNT(il.invoice_line_id) AS num_sales1,
		SUM(il.quantity) AS num_sales2,
		SUM(i.total) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	INNER JOIN track AS t
		ON il.track_id = t.track_id
	INNER JOIN customer AS c
		ON i.customer_id = c.customer_id
	GROUP BY c.country
)
SELECT
	ROUND(AVG(num_invoices)) AS "Average Number of Invoices Per Country",
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY num_invoices) AS "Median Number of Invoices Per Country"
FROM sub;
```

### 4. What are the top 10 countries by the number of invoices?

```sql
SELECT
	c.country AS "Country",
	COUNT(DISTINCT i.invoice_id) AS "Number of Invoices"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.country
ORDER BY "Number of Invoices" DESC
LIMIT 10;
```

### 5. What is the average and median revenue per country?

```sql
SELECT
	c.country,
	COUNT(DISTINCT i.invoice_id) AS num_invoices,
	COUNT(il.invoice_line_id) AS num_sales1,
	SUM(il.quantity) AS num_sales2,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.country;

WITH sub AS (
	SELECT
		c.country,
		COUNT(DISTINCT i.invoice_id) AS num_invoices,
		COUNT(il.invoice_line_id) AS num_sales1,
		SUM(il.quantity) AS num_sales2,
		SUM(i.total) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	INNER JOIN track AS t
		ON il.track_id = t.track_id
	INNER JOIN customer AS c
		ON i.customer_id = c.customer_id
	GROUP BY c.country
)
SELECT
	ROUND(AVG(revenue), 2) AS "Average Revenue Per Country",
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue) AS "Median Revenue Per Country"
FROM sub;
```

### 6. What are the top-10 countries by revenue?

```sql
SELECT
	c.country AS "Country",
	SUM(i.total) AS "Revenue"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.country
ORDER BY "Revenue" DESC
LIMIT 10;
```

### 7. Is there any correlation between the number of customers and the revenue by country? Are there countries with high customer count and low revenue?

```sql
SELECT
	c.country AS "Country",
	COUNT(c.customer_id) AS "Number of Customers",
	SUM(i.total) AS "Revenue"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.country
ORDER BY "Revenue" DESC;
```
