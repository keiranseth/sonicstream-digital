# Sales Performance

## Table of Contents

- [Sales Performance](#sales-performance)
	- [Table of Contents](#table-of-contents)
	- [1. How many invoices were made? How many sales were made? How much revenue was made?](#1-how-many-invoices-were-made-how-many-sales-were-made-how-much-revenue-was-made)
	- [2. What are the top-selling genres in terms of the number of sales?](#2-what-are-the-top-selling-genres-in-terms-of-the-number-of-sales)
	- [3. What are the top-selling genres in terms of the revenue?](#3-what-are-the-top-selling-genres-in-terms-of-the-revenue)
	- [4. What are the top-selling artists in terms of the number of sales?](#4-what-are-the-top-selling-artists-in-terms-of-the-number-of-sales)
	- [5. What are the top-selling artists in terms of the revenue?](#5-what-are-the-top-selling-artists-in-terms-of-the-revenue)
	- [6. What are the top-selling albums in terms of the number of sales?](#6-what-are-the-top-selling-albums-in-terms-of-the-number-of-sales)
	- [7. What are the top-selling albums in terms of the revenue?](#7-what-are-the-top-selling-albums-in-terms-of-the-revenue)
	- [8. What are the top-selling playlists in terms of the number of sales?](#8-what-are-the-top-selling-playlists-in-terms-of-the-number-of-sales)
	- [9. What are the top-selling playlists in terms of the revenue?](#9-what-are-the-top-selling-playlists-in-terms-of-the-revenue)

## 1. How many invoices were made? How many sales were made? How much revenue was made?

```sql
SELECT
	COUNT(DISTINCT il.invoice_id) AS num_unique_invoices,
	COUNT(DISTINCT il.invoice_line_id) AS num_invoiceLine_id,
	SUM(il.quantity) AS num_sales
FROM invoice AS i
INNER JOIN invoice_line AS il
	ON i.invoice_id = il.invoice_id;
```

```
"num_unique_invoices"	"num_invoiceline_id"	"num_sales"
412	2240	2240
```

```sql
SELECT SUM(total) AS sum_sales_total
FROM invoice
UNION ALL
SELECT SUM(quantity * unit_price) AS sum_priceXquantity
FROM invoice_line;
```

```
"sum_sales_total"
2328.60
2328.60
```

## 2. What are the top-selling genres in terms of the number of sales?

```sql
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
GROUP BY g.name;
```

```
"genre_name"	"num_invoices"	"num_invoice_lines"	"num_sales"
"Alternative"	4	14	14
"Alternative & Punk"	93	244	244
"Blues"	27	61	61
"Bossa Nova"	7	15	15
"Classical"	15	41	41
"Comedy"	5	9	9
"Drama"	14	29	29
"Easy Listening"	4	10	10
"Electronica/Dance"	7	12	12
"Heavy Metal"	5	12	12
"Hip Hop/Rap"	9	17	17
"Jazz"	41	80	80
"Latin"	117	386	386
"Metal"	96	264	264
"Pop"	13	28	28
"R&B/Soul"	18	41	41
"Reggae"	13	30	30
"Rock"	216	835	835
"Rock And Roll"	4	6	6
"Sci Fi & Fantasy"	10	20	20
"Science Fiction"	4	6	6
"Soundtrack"	12	20	20
"TV Shows"	19	47	47
"World"	9	13	13
```

```sql
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
```

```
"genre_name"	"num_invoices"
"Rock"	216
"Latin"	117
"Metal"	96
"Alternative & Punk"	93
"Jazz"	41
"Blues"	27
"TV Shows"	19
"R&B/Soul"	18
"Classical"	15
"Drama"	14
"Pop"	13
"Reggae"	13
"Soundtrack"	12
"Sci Fi & Fantasy"	10
"World"	9
"Hip Hop/Rap"	9
"Electronica/Dance"	7
"Bossa Nova"	7
"Comedy"	5
"Heavy Metal"	5
"Alternative"	4
"Rock And Roll"	4
"Easy Listening"	4
"Science Fiction"	4
```

```sql
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
```

```
"genre_name"	"num_invoice_lines"	"num_sales"
"Rock"	835	835
"Latin"	386	386
"Metal"	264	264
"Alternative & Punk"	244	244
"Jazz"	80	80
"Blues"	61	61
"TV Shows"	47	47
"Classical"	41	41
"R&B/Soul"	41	41
"Reggae"	30	30
"Drama"	29	29
"Pop"	28	28
"Sci Fi & Fantasy"	20	20
"Soundtrack"	20	20
"Hip Hop/Rap"	17	17
"Bossa Nova"	15	15
"Alternative"	14	14
"World"	13	13
"Electronica/Dance"	12	12
"Heavy Metal"	12	12
"Easy Listening"	10	10
"Comedy"	9	9
"Science Fiction"	6	6
"Rock And Roll"	6	6
```

## 3. What are the top-selling genres in terms of the revenue?

```sql
SELECT
	g.name AS genre_name,
	SUM(total) AS total_sales
FROM track AS t
INNER JOIN genre AS g
	ON t.genre_id = g.genre_id
INNER JOIN invoice_line AS il
	ON t.track_id = il.track_id
INNER JOIN invoice AS i
	ON il.invoice_id = i.invoice_id
GROUP BY g.name
ORDER BY total_sales DESC;
```

```
"genre_name"	"total_sales"
"Rock"	7720.02
"Latin"	3472.55
"Metal"	2093.13
"Alternative & Punk"	1961.66
"TV Shows"	817.71
"Jazz"	746.46
"Drama"	544.61
"Blues"	429.66
"R&B/Soul"	338.62
"Reggae"	332.64
"Classical"	317.04
"Soundtrack"	242.55
"Pop"	239.75
"Alternative"	211.17
"Sci Fi & Fantasy"	198.87
"World"	182.18
"Hip Hop/Rap"	166.41
"Heavy Metal"	161.37
"Electronica/Dance"	149.62
"Easy Listening"	138.60
"Comedy"	112.30
"Science Fiction"	102.41
"Bossa Nova"	86.13
"Rock And Roll"	83.16
```

## 4. What are the top-selling artists in terms of the number of sales?

```sql
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
ORDER BY num_sales DESC;
```

```
"artist"	"num_invoice_lines"	"num_sales"
"Iron Maiden"	140	140
"U2"	107	107
"Metallica"	91	91
"Led Zeppelin"	87	87
"Os Paralamas Do Sucesso"	45	45
"Deep Purple"	44	44
"Faith No More"	42	42
"Lost"	41	41
"Eric Clapton"	40	40
"R.E.M."	39	39
... ... ...
```

## 5. What are the top-selling artists in terms of the revenue?

```sql
SELECT
	ar.name AS artist,
	SUM(i.total) AS total_sales
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
ORDER BY total_sales DESC;
```

```
"artist"	"total_sales"
"Iron Maiden"	1233.54
"U2"	895.59
"Lost"	833.70
"Led Zeppelin"	620.73
"Metallica"	599.94
"Deep Purple"	550.44
"Pearl Jam"	408.87
"Lenny Kravitz"	372.51
"Van Halen"	336.82
"The Office"	328.80
```

## 6. What are the top-selling albums in terms of the number of sales?

```sql
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
ORDER BY num_sales DESC;
```

```
"album"	"num_invoice_lines"	"num_sales"
"Minha Historia"	27	27
"Greatest Hits"	26	26
"Unplugged"	25	25
"Acústico"	22	22
"Greatest Kiss"	20	20
"Chronicle, Vol. 2"	19	19
"My Generation - The Very Best Of The Who"	19	19
"Prenda Minha"	19	19
"Battlestar Galactica (Classic), Season 1"	18	18
"International Superhits"	18	18
... ... ...
```

## 7. What are the top-selling albums in terms of the revenue?

```sql
SELECT
	al.title AS album,
	SUM(i.total) AS total_sales
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
ORDER BY total_sales DESC;
```

```
"album"	"total_sales"
"Greatest Hits"	372.51
"Lost, Season 2"	290.18
"Heroes, Season 1"	238.61
"Lost, Season 1"	223.65
"Lost, Season 3"	211.80
"Battlestar Galactica, Season 3"	202.80
"Minha Historia"	185.13
"The Office, Season 3"	170.93
"Ao Vivo [IMPORT]"	161.74
"Battlestar Galactica (Classic), Season 1"	157.10
... ... ...
```

## 8. What are the top-selling playlists in terms of the number of sales?

```sql
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
```

```
"playlist"	"num_invoice_lines"	"num_sales"
"Music"	2240	11144
"Audiobooks"	2240	11144
"Movies"	2240	11144
"TV Shows"	2240	11144
"Classical 101 - Next Steps"	2240	5572
"Classical 101 - The Basics"	2240	5572
"90’s Music"	2240	5572
"Heavy Metal Classic"	2240	5572
"Music Videos"	2240	5572
"On-The-Go 1"	2240	5572
"Grunge"	2240	5572
"Brazilian Music"	2240	5572
"Classical"	2240	5572
"Classical 101 - Deep Cuts"	2240	5572
```

## 9. What are the top-selling playlists in terms of the revenue?

```sql
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
```

```
"playlist"	"total_sales"
"TV Shows"	102820.54
"Movies"	102820.54
"Audiobooks"	102820.54
"Music"	102820.54
"Grunge"	51410.27
"90’s Music"	51410.27
"Classical 101 - Deep Cuts"	51410.27
"Classical 101 - Next Steps"	51410.27
"Heavy Metal Classic"	51410.27
"Classical 101 - The Basics"	51410.27
"Brazilian Music"	51410.27
"On-The-Go 1"	51410.27
"Music Videos"	51410.27
"Classical"	51410.27
```

[def]: #questions
