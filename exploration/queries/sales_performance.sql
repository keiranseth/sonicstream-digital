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

-- 0. How many sales has SonicStream made?

SELECT
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id;

-- 1. How many invoices were made? How many sales were made? How much revenue was made?

SELECT
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales,
	SUM(i.total)
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id;

SELECT
	SUM(il.quantity * il.unit_price)
FROM track AS t
INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id;

WITH sub AS (
SELECT DISTINCT
	i.invoice_id,
	SUM(i.total) AS total,
	COUNT(il.quantity) AS num_sales
FROM track AS t
INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id
GROUP BY i.invoice_id
)
SELECT
	SUM(num_sales) AS num_sales
FROM sub;



-- 2. What's the average and median number of products/invoice lines per invoice? Average revenue per invoice?

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


-- 3. What's the average and median revenue per invoice?

WITH sub AS (
	SELECT
		invoice_id,
		SUM(total) AS sum_sales_total
	FROM invoice
	GROUP BY invoice_id
)
SELECT
	ROUND(AVG(sum_sales_total), 2) AS avg_total_per_invoice,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sum_sales_total) AS median_total_per_invoice
FROM sub;



-- 5. What are the top-selling genres in terms of the number of sales?

SELECT
	g.name AS genre_name,
	COUNT(DISTINCT i.invoice_id) AS num_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoice_lines,
	SUM(il.quantity) AS num_sales
FROM track AS t
INNER JOIN genre AS g
	ON t.genre_id = g.genre_id
INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id
GROUP BY g.name
ORDER BY num_sales DESC;

SELECT
	g.name AS genre_name,
	COUNT(DISTINCT i.invoice_id) AS num_invoices
FROM track AS t
INNER JOIN genre AS g
	ON t.genre_id = g.genre_id
INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id
GROUP BY g.name
ORDER BY num_invoices DESC;

SELECT
	g.name AS genre_name,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoice_lines,
	SUM(il.quantity) AS num_sales
FROM track AS t
INNER JOIN genre AS g
	ON t.genre_id = g.genre_id
INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id
GROUP BY g.name
ORDER BY num_sales DESC;


-- 6. What are the top-selling genres in terms of the revenue?

SELECT
	g.name AS genre_name,
	SUM(il.quantity * il.unit_price) AS total_sales
FROM track AS t
INNER JOIN genre AS g
	ON t.genre_id = g.genre_id
INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id
WHERE EXTRACT(YEAR FROM i.invoice_date) >= 2023
GROUP BY g.name
ORDER BY total_sales DESC;




-- 7. What are the top-selling artists in terms of the number of sales?

SELECT
	ar.name AS artist,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoice_lines,
	SUM(il.quantity) AS num_sales
FROM track AS t
INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id
INNER JOIN album AS al
	ON t.album_id = al.album_id
INNER JOIN artist AS ar
	ON al.artist_id = ar.artist_id
GROUP BY ar.name
ORDER BY num_sales DESC
LIMIT 20;

SELECT DISTINCT g.name AS genre
FROM genre AS g
INNER JOIN track AS t
	ON g.genre_id = t.genre_id
INNER JOIN album AS al
	ON t.album_id = al.album_id
INNER JOIN artist AS ar
	ON al.artist_id = ar.artist_id
WHERE ar.name IN (
	SELECT artist
	FROM (
		SELECT
			ar.name AS artist,
			COUNT(DISTINCT il.invoice_line_id) AS num_invoice_lines,
			SUM(il.quantity) AS num_sales
		FROM track AS t
		INNER JOIN invoice_line AS il
			ON t.track_id = il.track_id
		INNER JOIN invoice AS i
			ON il.invoice_id = i.invoice_id
		INNER JOIN album AS al
			ON t.album_id = al.album_id
		INNER JOIN artist AS ar
			ON al.artist_id = ar.artist_id
		GROUP BY ar.name
		ORDER BY num_sales DESC
		LIMIT 20
	)
);

-- 8. What are the top-selling artists in terms of the revenue?

SELECT
	ar.name AS artist,
	SUM(il.quantity * il.unit_price) AS total_sales
FROM track AS t
INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id
INNER JOIN album AS al
	ON t.album_id = al.album_id
INNER JOIN artist AS ar
	ON al.artist_id = ar.artist_id
GROUP BY ar.name
ORDER BY total_sales DESC
LIMIT 20;

SELECT DISTINCT g.name AS genre
FROM genre AS g
INNER JOIN track AS t
	ON g.genre_id = t.genre_id
INNER JOIN album AS al
	ON t.album_id = al.album_id
INNER JOIN artist AS ar
	ON al.artist_id = ar.artist_id
WHERE ar.name IN (
	SELECT artist
	FROM (
		SELECT
			ar.name AS artist,
			SUM(il.quantity * il.unit_price) AS total_sales
		FROM track AS t
		INNER JOIN invoice_line AS il
			ON t.track_id = il.track_id
		INNER JOIN invoice AS i
			ON il.invoice_id = i.invoice_id
		INNER JOIN album AS al
			ON t.album_id = al.album_id
		INNER JOIN artist AS ar
			ON al.artist_id = ar.artist_id
		GROUP BY ar.name
		ORDER BY total_sales DESC
		LIMIT 20
	)
);


-- 9. What are the top-selling albums in terms of the number of sales?

SELECT
	al.title AS album,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoice_lines,
	SUM(il.quantity) AS num_sales
FROM track AS t
INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id
INNER JOIN album AS al
	ON t.album_id = al.album_id
INNER JOIN artist AS ar
	ON al.artist_id = ar.artist_id
GROUP BY al.title
ORDER BY num_sales DESC
LIMIT 20;

SELECT DISTINCT g.name
FROM track AS t
INNER JOIN album AS al
	ON t.album_id = al.album_id
INNER JOIN genre AS g
	ON t.genre_id = g.genre_id
WHERE al.title IN (
	SELECT album
	FROM (
		SELECT
			al.title AS album,
			COUNT(DISTINCT il.invoice_line_id) AS num_invoice_lines,
			SUM(il.quantity) AS num_sales
		FROM track AS t
		INNER JOIN invoice_line AS il
			ON t.track_id = il.track_id
		INNER JOIN invoice AS i
			ON il.invoice_id = i.invoice_id
		INNER JOIN album AS al
			ON t.album_id = al.album_id
		INNER JOIN artist AS ar
			ON al.artist_id = ar.artist_id
		GROUP BY al.title
		ORDER BY num_sales DESC
		LIMIT 20
	)
);


-- 10. What are the top-selling albums in terms of the revenue?

SELECT
	al.title AS album,
	SUM(il.quantity * il.unit_price) AS total_sales
FROM track AS t
INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id
INNER JOIN album AS al
	ON t.album_id = al.album_id
INNER JOIN artist AS ar
	ON al.artist_id = ar.artist_id
GROUP BY al.title
ORDER BY total_sales DESC
LIMIT 20;


SELECT DISTINCT g.name
FROM track AS t
INNER JOIN album AS al
	ON t.album_id = al.album_id
INNER JOIN genre AS g
	ON t.genre_id = g.genre_id
WHERE al.title IN (
	SELECT album
	FROM (
		SELECT
			al.title AS album,
			SUM(il.quantity * il.unit_price) AS total_sales
		FROM track AS t
		INNER JOIN invoice_line AS il
			ON t.track_id = il.track_id
		INNER JOIN invoice AS i
			ON il.invoice_id = i.invoice_id
		INNER JOIN album AS al
			ON t.album_id = al.album_id
		INNER JOIN artist AS ar
			ON al.artist_id = ar.artist_id
		GROUP BY al.title
		ORDER BY total_sales DESC
		LIMIT 20
	)
);


-- 11. What are the top-selling playlists in terms of the number of sales?

SELECT
	p.name AS playlist,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoice_lines,
	SUM(il.quantity) AS num_sales
FROM track AS t
INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id
LEFT JOIN playlist_track AS pt
	ON t.track_id = pt.track_id
INNER JOIN playlist AS p
	ON pt.playlist_id = pt.playlist_id
GROUP BY p.name
ORDER BY num_sales DESC;

-- 12. What are the top-selling playlists in terms of the revenue?

SELECT
	p.name AS playlist,
	SUM(i.total) AS total_sales
FROM track AS t
INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id
LEFT JOIN playlist_track AS pt
	ON t.track_id = pt.track_id
INNER JOIN playlist AS p
	ON pt.playlist_id = pt.playlist_id
GROUP BY p.name
ORDER BY total_sales DESC;
