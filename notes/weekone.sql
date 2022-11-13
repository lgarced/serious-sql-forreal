
--EXAMPLE QUERY
SELECT 
    column_name_1,
    column_name_2,
FROM schema_name.table_name


--All columns
SELECT *
FROM balanced_tree.product_details;

--Selected columns
SELECT
    language_id,
    name
FROM dvd_rentals.language

--Limiting the number of rows returned
SELECT *
FROM dvd_rentals.actor
LIMIT 10;

--Sorting the results on alphabetical order ASC
SELECT country
FROM dvd_rentals.country
ORDER BY country --after the FROM but before the LIMIT
LIMIT 5;

--Sorting the results on alphabetical order DESC
SELECT country
FROM dvd_rentals.country
ORDER BY country DESC --after the FROM but before the LIMIT
LIMIT 5;

--Sort with multiple columns
SELECT 
    category,
    total_sales
FROM dvd_rentals.sales_by_film_category
ORDER BY total_sales
LIMIT 1;

--Sort by decending order limit 1
SELECT 
    payment_date
FROM dvd_rentals.payment
ORDER BY payment_date DESC
LIMIT 1;

--SORT BY MULTIPLE COLUMNS
--Windows functions help to sort by multiple columns
--CREATING TEMP TABLE AND CTE
DROP TABLE IF EXISTS sample_table;
CREATE TEMP TABLE sample_table AS
WITH raw_data (id, column_a, column_b) AS (
VALUES 
(1,0,'A'),
(2,0,'B'),
(3,1,'C'),
(4,1,'D'),
(5,2,'E'),
(6,3,'F')
)

SELECT *
FROM raw_data;

SELECT * 
FROM sample_table;

--SORT BY MULTIPLE COLUMNS WITH DESC AND ASC
SELECT * 
FROM sample_table
ORDER BY column_a DESC, column_b;

--Count of rows plus column alias
SELECT
    COUNT(*) AS row_count
FROM dvd_rentals.film_list;

--Unique column values
SELECT DISTINCT
    rating
FROM dvd_rentals.film_list;

--Count of unique column values
SELECT
    COUNT(DISTINCT category) AS unique_category_count
FROM dvd_rentals.film_list;

--Group by and count
SELECT
    rating,
    COUNT(*) AS frequency --Agregate function does not have to be included on the GROUP BY
FROM dvd_rentals.film_list
GROUP BY rating;

--Group by and adding a percentage
SELECT
    rating,
    COUNT(*) AS frequency,
    COUNT(*)::NUMERIC / SUM(COUNT(*)) OVER () AS percentage --This is what is called a window function
FROM dvd_rentals.film_list
GROUP BY rating
ORDER BY frequency DESC;

--Multiple columns group by the 5 most frequent
SELECT 
    rating,
    category,
    COUNT(*) AS frequency
FROM dvd_rentals.film_list
GROUP BY rating, category
ORDER BY frequency DESC 
LIMIT 5;

--Group by ordinal syntax
SELECT
    rating,
    category,
    COUNT(*) AS frequency
FROM dvd_rentals.film_list
GROUP BY 1, 2
