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
ORDER BY num_invoices DESC;



-- 1. 

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



-- 2.

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

-- 3. 

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

-- 4.

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

SELECT
	c.country AS "Country",
	EXTRACT(YEAR FROM i.invoice_date) AS "Year",
	COUNT(i.invoice_id) AS "Number of Invoices"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY 
	EXTRACT(YEAR FROM i.invoice_date),
	c.country
ORDER BY 
	"Number of Invoices" DESC,
	"Year" ASC;

-- 5.

SELECT
	c.country,
	COUNT(DISTINCT i.invoice_id) AS num_invoices,
	COUNT(il.invoice_line_id) AS num_sales1,
	SUM(il.quantity) AS num_sales2,
	SUM(il.quantity * il.unit_price) AS revenue
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
		SUM(il.quantity * il.unit_price) AS revenue
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


-- 6.

SELECT
	c.country AS "Country",
	SUM(il.quantity * il.unit_price) AS "Revenue"
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



-- 7.

SELECT
	c.country AS "Country",
	COUNT(c.customer_id) AS "Number of Customers",
	SUM(il.quantity * il.unit_price) AS "Revenue"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN track AS t
	ON il.track_id = t.track_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.country
ORDER BY "Revenue" DESC;
