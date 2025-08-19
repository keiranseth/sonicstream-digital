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

-- 1

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


-- 2

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
	COUNT(invoice_id) AS num_invoices
FROM sub
GROUP BY num_sales
ORDER BY num_sales;


-- 3 

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



-- 4

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




-- 5

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


-- 6

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


-- 7

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


-- 8

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
	ROUND(AVG(num_sales)) AS mean_tracks_yearly,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY num_sales) AS median_tracks_yearly,
	ROUND(AVG(revenue), 2) AS mean_revenue_yearly,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue) AS median_revenue_yearly
FROM sub;

