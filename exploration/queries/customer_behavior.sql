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


SELECT *
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id;

SELECT
	c.customer_id AS "Customer ID",
	COUNT(il.invoice_id) AS "Number of Invoice Lines",
	SUM(il.quantity) AS "Number of Sales",
	SUM(i.total) AS "Revenue"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.customer_id;

-- 1. 

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


-- 2.

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


-- 3.

SELECT
	c.customer_id AS "Customer ID",
	SUM(il.quantity * il.unit_price) AS "Revenue"
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
		SUM(il.quantity * il.unit_price) AS "Revenue"
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


-- 4

WITH sub1 AS (
	SELECT SUM(quantity * unit_price) AS "Revenue"
	FROM invoice_line
),
sub2 AS (
	SELECT SUM(quantity) "Number of Sales"
	FROM invoice_line
)
SELECT 
	*, 
	"Revenue" / "Number of Sales" AS "Average Order Value"
FROM sub1, sub2;


SELECT SUM(unit_price)/SUM(quantity)
FROM invoice_line;

-- 5.

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


SELECT ROUND(AVG("Order Frequency Per Year"), 2) AS "Average Order Frequency"
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



-- 6.

WITH sub1 AS (
	SELECT SUM(quantity * unit_price) AS "Revenue"
	FROM invoice_line
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


-- 7.

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



SELECT EXTRACT(EPOCH FROM '1 hour'::interval)::integer;

-- 8.

WITH sub1 AS (
	SELECT SUM(quantity * unit_price) AS "Revenue"
	FROM invoice_line
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