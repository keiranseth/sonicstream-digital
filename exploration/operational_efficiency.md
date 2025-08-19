# Operational Efficiency

## Table of Contents

- [Operational Efficiency](#operational-efficiency)
	- [Table of Contents](#table-of-contents)
	- [Questions](#questions)
		- [1. What's the average and median number of products/invoice lines per invoice?](#1-whats-the-average-and-median-number-of-productsinvoice-lines-per-invoice)
		- [2. What's the distribution of invoices by the number of tracks being sold?](#2-whats-the-distribution-of-invoices-by-the-number-of-tracks-being-sold)
		- [3. What's the average and median revenue per invoice?](#3-whats-the-average-and-median-revenue-per-invoice)
		- [4. What's the distribution of invoices by the revenue?](#4-whats-the-distribution-of-invoices-by-the-revenue)
		- [5. How many tracks are being sold weekly? How much revenue is generated weekly?](#5-how-many-tracks-are-being-sold-weekly-how-much-revenue-is-generated-weekly)
		- [6. How many tracks are being sold monthly? How much revenue is generated monthly?](#6-how-many-tracks-are-being-sold-monthly-how-much-revenue-is-generated-monthly)
		- [7. How many tracks are being sold quarterly? How much revenue is generated quarterly?](#7-how-many-tracks-are-being-sold-quarterly-how-much-revenue-is-generated-quarterly)
		- [8. How many tracks are being sold yearly? How much revenue is generated yearly?](#8-how-many-tracks-are-being-sold-yearly-how-much-revenue-is-generated-yearly)

## Questions

### 1. What's the average and median number of products/invoice lines per invoice?

```sql
WITH sub AS (
	SELECT
		i.invoice_id,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY i.invoice_id
)
SELECT
	ROUND(AVG(num_unique_invoices), 0) AS avg_unique_invoices,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY num_unique_invoices) AS median_unique_invoices,
	ROUND(AVG(num_invoiceLine_id), 2) AS avg_invoiceLines,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY num_invoiceLine_id) AS median_unique_invoiceLine_id,
	ROUND(AVG(num_sales), 2) AS avg_num_sales,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY num_sales) AS median_num_sales
FROM sub;
```

### 2. What's the distribution of invoices by the number of tracks being sold?

```sql
SELECT
	i.invoice_id,
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
GROUP BY i.invoice_id
ORDER BY 4 DESC;

WITH sub AS (
	SELECT
		i.invoice_id,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY i.invoice_id
	ORDER BY 4 DESC
)
SELECT
	num_sales,
	COUNT(*) AS num_invoices
FROM sub
GROUP BY num_sales
ORDER BY num_sales;
```

### 3. What's the average and median revenue per invoice?

```sql
SELECT
	i.invoice_id,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
GROUP BY i.invoice_id;

WITH sub AS (
	SELECT
		i.invoice_id,
		SUM(i.total) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY i.invoice_id
)
SELECT
	ROUND(AVG(revenue)) AS avg_revenue,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue) AS median_revenue
FROM sub;
```

### 4. What's the distribution of invoices by the revenue?

```sql
SELECT
	i.invoice_id,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
GROUP BY i.invoice_id;

WITH sub AS (
	SELECT
		i.invoice_id,
		SUM(i.total) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY i.invoice_id
)
SELECT
	revenue,
	COUNT(*)
FROM sub
GROUP BY revenue
ORDER BY revenue;
```

### 5. How many tracks are being sold weekly? How much revenue is generated weekly?

```sql
SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS year,
	EXTRACT(WEEK FROM i.invoice_date) AS week,
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
GROUP BY
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(WEEK FROM i.invoice_date);

WITH sub AS (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		EXTRACT(WEEK FROM i.invoice_date) AS week,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales,
		SUM(i.total) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(WEEK FROM i.invoice_date)
)
SELECT
	ROUND(AVG(num_sales)) AS mean_tracks_weekly,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY num_sales) AS median_tracks_weekly,
	ROUND(AVG(revenue), 2) AS mean_revenue_weekly,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue) AS median_revenue_weekly
FROM sub;
```

### 6. How many tracks are being sold monthly? How much revenue is generated monthly?

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

WITH sub AS (
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
)
SELECT
	ROUND(AVG(num_sales), 2) AS mean_tracks_monthly,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY num_sales) AS median_tracks_monthly,
	ROUND(AVG(revenue), 2) AS mean_revenue_monthly,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue) AS median_revenue_monthly
FROM sub;
```

### 7. How many tracks are being sold quarterly? How much revenue is generated quarterly?

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
	EXTRACT(QUARTER FROM i.invoice_date);

WITH sub AS (
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
)
SELECT
	ROUND(AVG(num_sales), 2) AS mean_tracks_quarterly,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY num_sales) AS median_tracks_quarterly,
	ROUND(AVG(revenue), 2) AS mean_revenue_quarterly,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue) AS median_revenue_quarterly
FROM sub;
```

### 8. How many tracks are being sold yearly? How much revenue is generated yearly?

```sql
SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS year,
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales,
	SUM(i.total) AS revenue
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
GROUP BY
	EXTRACT(YEAR FROM i.invoice_date);

WITH sub AS (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS year,
		COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
		COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
		SUM(il.quantity) AS num_sales,
		SUM(i.total) AS revenue
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	GROUP BY
		EXTRACT(YEAR FROM i.invoice_date)
)
SELECT
	ROUND(AVG(num_sales)) AS mean_tracks_quarterly,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY num_sales) AS median_tracks_quarterly,
	ROUND(AVG(revenue), 2) AS mean_revenue_quarterly,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue) AS median_revenue_quarterly
FROM sub;
```
