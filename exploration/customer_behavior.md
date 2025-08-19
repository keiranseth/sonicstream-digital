# Customer Behavior

## Tables of Contents

- [Customer Behavior](#customer-behavior)
	- [Tables of Contents](#tables-of-contents)
	- [Questions](#questions)
		- [1. What's the average and median number of products/invoice lines per customer?](#1-whats-the-average-and-median-number-of-productsinvoice-lines-per-customer)
		- [2. What's the average and median number of tracks per customer?](#2-whats-the-average-and-median-number-of-tracks-per-customer)
		- [3. What's the average and median revenue per customer?](#3-whats-the-average-and-median-revenue-per-customer)
		- [4. What is the average order value?](#4-what-is-the-average-order-value)
		- [5. What is the average purchase frequency?](#5-what-is-the-average-purchase-frequency)
		- [6. What is the customer value?](#6-what-is-the-customer-value)
		- [7. What is the average customer lifespan?](#7-what-is-the-average-customer-lifespan)
		- [8. What is the average customer lifetime value?](#8-what-is-the-average-customer-lifetime-value)
	- [Sources](#sources)

## Questions

### 1. What's the average and median number of products/invoice lines per customer?

```sql
SELECT
	c.customer_id AS "Customer ID",
	COUNT(il.invoice_id) AS "Number of Invoice Lines",
	SUM(il.quantity) AS "Number of Sales"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY "Number of Sales" DESC;

WITH sub AS (
	SELECT
		c.customer_id AS "Customer ID",
		COUNT(il.invoice_id) AS "Number of Invoice Lines",
		SUM(il.quantity) AS "Number of Sales"
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	INNER JOIN track AS t
		ON il.track_id = t.track_id
	INNER JOIN customer AS c
		ON i.customer_id = c.customer_id
	GROUP BY c.customer_id
	ORDER BY "Number of Sales" DESC
)
SELECT
	ROUND(AVG("Number of Sales")) AS "Average Number of Sales",
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "Number of Sales") AS "Median Number of Sales"
FROM sub;
```

### 2. What's the average and median number of tracks per customer?

```sql
SELECT
	c.customer_id AS "Customer ID",
	COUNT(t.track_id) AS "Number of Tracks"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY "Number of Tracks" DESC;

WITH sub AS (
	SELECT
		c.customer_id AS "Customer ID",
		COUNT(t.track_id) AS "Number of Tracks"
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	INNER JOIN track AS t
		ON il.track_id = t.track_id
	INNER JOIN customer AS c
		ON i.customer_id = c.customer_id
	GROUP BY c.customer_id
	ORDER BY "Number of Tracks" DESC
)
SELECT
	ROUND(AVG("Number of Tracks")) AS "Average Number of Tracks",
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "Number of Tracks") AS "Median Number of Tracks"
FROM sub;
```

### 3. What's the average and median revenue per customer?

```sql
SELECT
	c.customer_id AS "Customer ID",
	SUM(i.total) AS "Revenue"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY "Revenue" DESC;

WITH sub AS (
	SELECT
		c.customer_id AS "Customer ID",
		SUM(i.total) AS "Revenue"
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	INNER JOIN track AS t
		ON il.track_id = t.track_id
	INNER JOIN customer AS c
		ON i.customer_id = c.customer_id
	GROUP BY c.customer_id
	ORDER BY "Revenue" DESC
)
SELECT
	ROUND(AVG("Revenue"), 2) AS "Average Revenue",
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "Revenue") AS "Median Revenue"
FROM sub;
```

### 4. What is the average order value?

```sql
WITH sub1 AS (
	SELECT SUM(total) AS "Revenue"
	FROM invoice
),
sub2 AS (
	SELECT SUM(quantity) "Number of Sales"
	FROM invoice_line
)
SELECT
	*,
	"Revenue" / "Number of Sales" AS "Average Order Value"
FROM sub1, sub2;
```

### 5. What is the average purchase frequency?

```sql
SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS "Year",
	COUNT(DISTINCT c.customer_id) AS "Number of Unique Customers",
	SUM(il.quantity) AS "Number of Orders",
	1.0 * (SUM(il.quantity)) / (COUNT(DISTINCT c.customer_id)) AS "Order Frequency Per Year"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN customer AS c
	ON c.customer_id = i.customer_id
GROUP BY EXTRACT(YEAR FROM i.invoice_date)
ORDER BY EXTRACT(YEAR FROM i.invoice_date);

WITH sub AS (
	SELECT
		EXTRACT(YEAR FROM i.invoice_date) AS "Year",
		COUNT(DISTINCT c.customer_id) AS "Number of Unique Customers",
		SUM(il.quantity) AS "Number of Orders",
		1.0 * (SUM(il.quantity)) / (COUNT(DISTINCT c.customer_id)) AS "Order Frequency Per Year"
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	INNER JOIN customer AS c
		ON c.customer_id = i.customer_id
	GROUP BY EXTRACT(YEAR FROM i.invoice_date)
	ORDER BY EXTRACT(YEAR FROM i.invoice_date)
)
SELECT ROUND(AVG("Order Frequency Per Year"), 2) AS "Average Order Frequency"
FROM sub;
```

### 6. What is the customer value?

```sql
WITH sub1 AS (
	SELECT SUM(total) AS "Revenue"
	FROM invoice
),
sub2 AS (
	SELECT SUM(quantity) "Number of Sales"
	FROM invoice_line
),
sub3 AS (
	SELECT AVG("Order Frequency Per Year") AS "Average Order Frequency"
	FROM (
		SELECT
			EXTRACT(YEAR FROM i.invoice_date) AS "Year",
			COUNT(DISTINCT c.customer_id) AS "Number of Unique Customers",
			SUM(il.quantity) AS "Number of Orders",
			1.0 * (SUM(il.quantity)) / (COUNT(DISTINCT c.customer_id)) AS "Order Frequency Per Year"
		FROM invoice AS i
		INNER JOIN invoice_line AS il
			ON i.invoice_id = il.invoice_id
		INNER JOIN customer AS c
			ON c.customer_id = i.customer_id
		GROUP BY EXTRACT(YEAR FROM i.invoice_date)
		ORDER BY EXTRACT(YEAR FROM i.invoice_date)
	)
)
SELECT
	"Average Order Frequency",
	"Revenue" / "Number of Sales" AS "Average Order Value",
	"Average Order Frequency" * ("Revenue" / "Number of Sales") AS "Customer Value"
FROM sub1, sub2, sub3;
```

### 7. What is the average customer lifespan?

```sql
SELECT
	c.customer_id,
	MIN(i.invoice_date) AS first_transaction,
	MAX(i.invoice_date) AS recent_transaction,
	MAX(i.invoice_date) - MIN(i.invoice_date) AS customer_lifespan
FROM customer AS c
INNER JOIN invoice AS i
	ON c.customer_id = i.customer_id
GROUP BY c.customer_id;

WITH sub AS (
	SELECT
		c.customer_id,
		MIN(i.invoice_date) AS first_transaction,
		MAX(i.invoice_date) AS recent_transaction,
		MAX(i.invoice_date) - MIN(i.invoice_date) AS customer_lifespan
	FROM customer AS c
	INNER JOIN invoice AS i
		ON c.customer_id = i.customer_id
	GROUP BY c.customer_id
)
SELECT
	EXTRACT(EPOCH FROM AVG(customer_lifespan)) / (1 * 365.34 * 24 * 60 * 60) "Average Customer Lifespan",
	(EXTRACT(EPOCH FROM PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY customer_lifespan))) / (1 * 365.34 * 24 * 60 * 60) AS "Median Customer Lifespan"
FROM sub;
```

### 8. What is the average customer lifetime value?

```sql
WITH sub1 AS (
	SELECT SUM(total) AS "Revenue"
	FROM invoice
),
sub2 AS (
	SELECT SUM(quantity) "Number of Sales"
	FROM invoice_line
),
sub3 AS (
	SELECT AVG("Order Frequency Per Year") AS "Average Order Frequency"
	FROM (
		SELECT
			EXTRACT(YEAR FROM i.invoice_date) AS "Year",
			COUNT(DISTINCT c.customer_id) AS "Number of Unique Customers",
			SUM(il.quantity) AS "Number of Orders",
			1.0 * (SUM(il.quantity)) / (COUNT(DISTINCT c.customer_id)) AS "Order Frequency Per Year"
		FROM invoice AS i
		INNER JOIN invoice_line AS il
			ON i.invoice_id = il.invoice_id
		INNER JOIN customer AS c
			ON c.customer_id = i.customer_id
		GROUP BY EXTRACT(YEAR FROM i.invoice_date)
		ORDER BY EXTRACT(YEAR FROM i.invoice_date)
	)
),
sub4 AS (
	SELECT
		c.customer_id,
		MIN(i.invoice_date) AS first_transaction,
		MAX(i.invoice_date) AS recent_transaction,
		MAX(i.invoice_date) - MIN(i.invoice_date) AS customer_lifespan
	FROM customer AS c
	INNER JOIN invoice AS i
		ON c.customer_id = i.customer_id
	GROUP BY c.customer_id
),
sub5 AS (
	SELECT
		EXTRACT(EPOCH FROM AVG(customer_lifespan)) / (1 * 365.34 * 24 * 60 * 60) "Average Customer Lifespan",
		(EXTRACT(EPOCH FROM PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY customer_lifespan))) / (1 * 365.34 * 24 * 60 * 60) AS "Median Customer Lifespan"
	FROM sub4
)
SELECT
	"Average Order Frequency",
	"Revenue" / "Number of Sales" AS "Average Order Value",
	"Average Customer Lifespan",
	("Average Order Frequency" * ("Revenue" / "Number of Sales")) * "Average Customer Lifespan" AS "Customer Lifetime Value"
FROM sub1, sub2, sub3, sub5;
```

## Sources

-   https://www.shopify.com/blog/customer-lifetime-value#
-   https://corporatefinanceinstitute.com/resources/valuation/lifetime-value-calculation/
