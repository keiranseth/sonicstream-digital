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




-- 1.

SELECT
	e.first_name AS "Sales Agent",
	SUM(il.quantity) AS "Number of Sales"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
INNER JOIN employee AS e
	ON c.support_rep_id = e.employee_id
WHERE e.title LIKE '%Sales%'
GROUP BY e.first_name
ORDER BY "Number of Sales" DESC;


-- 2.

SELECT
	e.first_name AS "Sales Agent",
	SUM(il.quantity * il.unit_price) AS "Revenue"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
INNER JOIN employee AS e
	ON c.support_rep_id = e.employee_id
WHERE e.title LIKE '%Sales%'
GROUP BY e.first_name
ORDER BY "Revenue" DESC;



-- 3.

SELECT
	e.first_name AS "Sales Agent",
	SUM(il.quantity) AS "Number of Sales"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
INNER JOIN employee AS e
	ON c.support_rep_id = e.employee_id
WHERE e.title LIKE '%Sales%'
GROUP BY e.first_name
ORDER BY "Number of Sales" DESC;

SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS "Year",
	SUM(il.quantity) FILTER (WHERE e.first_name = 'Jane') AS "Jane",
	SUM(il.quantity) FILTER (WHERE e.first_name = 'Margaret') AS "Margaret",
	SUM(il.quantity) FILTER (WHERE e.first_name = 'Steve') AS "Steve"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
INNER JOIN employee AS e
	ON c.support_rep_id = e.employee_id
WHERE e.title LIKE '%Sales%'
GROUP BY EXTRACT(YEAR FROM i.invoice_date)
ORDER BY EXTRACT(YEAR FROM i.invoice_date);



-- 4.

SELECT
	e.first_name AS "Sales Agent",
	SUM(il.quantity * il.unit_price) AS "Revenue"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
INNER JOIN employee AS e
	ON c.support_rep_id = e.employee_id
WHERE e.title LIKE '%Sales%'
GROUP BY e.first_name
ORDER BY "Revenue" DESC;

SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS "Year",
	SUM(il.quantity * il.unit_price) FILTER (WHERE e.first_name = 'Jane') AS "Jane",
	SUM(il.quantity * il.unit_price) FILTER (WHERE e.first_name = 'Margaret') AS "Margaret",
	SUM(il.quantity * il.unit_price) FILTER (WHERE e.first_name = 'Steve') AS "Steve"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
INNER JOIN employee AS e
	ON c.support_rep_id = e.employee_id
WHERE e.title LIKE '%Sales%'
GROUP BY EXTRACT(YEAR FROM i.invoice_date)
ORDER BY EXTRACT(YEAR FROM i.invoice_date);


-- 5.

SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS "Year",
	EXTRACT(MONTH FROM i.invoice_date) AS "Month",
	SUM(il.quantity * il.unit_price) FILTER (WHERE e.first_name = 'Jane') AS "Jane",
	SUM(il.quantity * il.unit_price) FILTER (WHERE e.first_name = 'Margaret') AS "Margaret",
	SUM(il.quantity * il.unit_price) FILTER (WHERE e.first_name = 'Steve') AS "Steve"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
INNER JOIN employee AS e
	ON c.support_rep_id = e.employee_id
WHERE e.title LIKE '%Sales%'
GROUP BY 
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(MONTH FROM i.invoice_date)
ORDER BY 
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(MONTH FROM i.invoice_date);




-- Year and Quarter
WITH sub AS (
	SELECT
		e.first_name AS "Sales Rep",
		EXTRACT(YEAR FROM i.invoice_date) AS "Year",
		EXTRACT(QUARTER FROM i.invoice_date) AS "Quarter",
		SUM(il.quantity) AS "Number of Sales"
	FROM invoice AS i
	INNER JOIN invoice_line AS il
		ON i.invoice_id = il.invoice_id
	INNER JOIN customer AS c
		ON i.customer_id = c.customer_id
	INNER JOIN employee AS e
		ON c.support_rep_id = e.employee_id
	WHERE e.title LIKE '%Sales%'
	GROUP BY 
		e.first_name,
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(QUARTER FROM i.invoice_date)
	ORDER BY
		e.first_name,
		EXTRACT(YEAR FROM i.invoice_date),
		EXTRACT(QUARTER FROM i.invoice_date)
)
SELECT
	AVG("Number of Sales") AS "Average Quarterly Number of Sales Per Rep"
FROM sub;

SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS "Year",
	EXTRACT(QUARTER FROM i.invoice_date) AS "Quarter",
	SUM(il.quantity) FILTER (WHERE e.first_name = 'Jane') AS "Jane",
	SUM(il.quantity) FILTER (WHERE e.first_name = 'Margaret') AS "Margaret",
	SUM(il.quantity) FILTER (WHERE e.first_name = 'Steve') AS "Steve"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
INNER JOIN employee AS e
	ON c.support_rep_id = e.employee_id
WHERE e.title LIKE '%Sales%'
GROUP BY 
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(QUARTER FROM i.invoice_date)
ORDER BY 
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(QUARTER FROM i.invoice_date);

SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS "Year",
	EXTRACT(QUARTER FROM i.invoice_date) AS "Quarter",
	SUM(il.quantity * il.unit_price) FILTER (WHERE e.first_name = 'Jane') AS "Jane",
	SUM(il.quantity * il.unit_price) FILTER (WHERE e.first_name = 'Margaret') AS "Margaret",
	SUM(il.quantity * il.unit_price) FILTER (WHERE e.first_name = 'Steve') AS "Steve"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
INNER JOIN employee AS e
	ON c.support_rep_id = e.employee_id
WHERE e.title LIKE '%Sales%'
GROUP BY 
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(QUARTER FROM i.invoice_date)
ORDER BY 
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(QUARTER FROM i.invoice_date);


-- Year and Month

SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS "Year",
	EXTRACT(MONTH FROM i.invoice_date) AS "Month",
	SUM(il.quantity) FILTER (WHERE e.first_name = 'Jane') AS "Jane",
	SUM(il.quantity) FILTER (WHERE e.first_name = 'Margaret') AS "Margaret",
	SUM(il.quantity) FILTER (WHERE e.first_name = 'Steve') AS "Steve"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
INNER JOIN employee AS e
	ON c.support_rep_id = e.employee_id
WHERE e.title LIKE '%Sales%'
GROUP BY 
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(MONTH FROM i.invoice_date)
ORDER BY 
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(MONTH FROM i.invoice_date);

SELECT
	EXTRACT(YEAR FROM i.invoice_date) AS "Year",
	EXTRACT(MONTH FROM i.invoice_date) AS "Month",
	SUM(il.quantity * il.unit_price) FILTER (WHERE e.first_name = 'Jane') AS "Jane",
	SUM(il.quantity * il.unit_price) FILTER (WHERE e.first_name = 'Margaret') AS "Margaret",
	SUM(il.quantity * il.unit_price) FILTER (WHERE e.first_name = 'Steve') AS "Steve"
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id
INNER JOIN customer AS c
	ON i.customer_id = c.customer_id
INNER JOIN employee AS e
	ON c.support_rep_id = e.employee_id
WHERE e.title LIKE '%Sales%'
GROUP BY 
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(MONTH FROM i.invoice_date)
ORDER BY 
	EXTRACT(YEAR FROM i.invoice_date),
	EXTRACT(MONTH FROM i.invoice_date);

-- 6.

SELECT
	e.first_name AS "Sales Agent",
	COUNT(DISTINCT c.customer_id) AS "Number of Unique Customers"
FROM employee AS e
INNER JOIN customer AS c
	ON e.employee_id = c.support_rep_id
GROUP BY e.first_name;



-- 7.

SELECT
	e.first_name AS "Sales Agent",
	COUNT(c.customer_id) AS "Number of Unique Customers",
	1.0 * COUNT(c.customer_id) / (
		SELECT COUNT(*)
		FROM customer
	) AS "Customer Coverage Ratio"
FROM employee AS e
INNER JOIN customer AS c
	ON e.employee_id = c.support_rep_id
GROUP BY e.first_name;