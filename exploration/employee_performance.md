# Employee Performance

## Tables of Contents

- [Employee Performance](#employee-performance)
	- [Tables of Contents](#tables-of-contents)
	- [Questions](#questions)
		- [What is the number of unique customers served per representative?](#what-is-the-number-of-unique-customers-served-per-representative)
		- [What is the customer coverage ratio of the sales representatives?](#what-is-the-customer-coverage-ratio-of-the-sales-representatives)
		- [Which support representative has facilitated the highest number of sales?](#which-support-representative-has-facilitated-the-highest-number-of-sales)
		- [Which support representative has facilitated the highest amount of revenue?](#which-support-representative-has-facilitated-the-highest-amount-of-revenue)
		- [How many sales did each representative make over time?](#how-many-sales-did-each-representative-make-over-time)
		- [How much revenue did each representative generate over time?](#how-much-revenue-did-each-representative-generate-over-time)

## Questions

### What is the number of unique customers served per representative?

```sql
SELECT
	e.first_name AS "Sales Agent",
	COUNT(DISTINCT c.customer_id) AS "Number of Unique Customers"
FROM employee AS e
INNER JOIN customer AS c
	ON e.employee_id = c.support_rep_id
GROUP BY e.first_name;
```

### What is the customer coverage ratio of the sales representatives?

```sql
SELECT
	e.first_name AS "Sales Agent",
	COUNT(c.customer_id) AS "Number of Unique Customers",
	100.0 * COUNT(c.customer_id) / (
		SELECT COUNT(*)
		FROM customer
	) AS "Customer Coverage Ratio"
FROM employee AS e
INNER JOIN customer AS c
	ON e.employee_id = c.support_rep_id
GROUP BY e.first_name;
```

### Which support representative has facilitated the highest number of sales?

```sql
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
```

### Which support representative has facilitated the highest amount of revenue?

```sql
SELECT
	e.first_name AS "Sales Agent",
	SUM(i.total) AS "Revenue"
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
```

### How many sales did each representative make over time?

```sql
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
```

### How much revenue did each representative generate over time?

```sql
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
```

```sql
-- Year and Quarter

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
```
