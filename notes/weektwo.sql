--Week two notes
--Finding number of ways mesaurment can be made
SELECT measure,
      COUNT(*) AS frequency
FROM health.user_logs
GROUP BY measure;

--Finding how many customers 
SELECT 
    COUNT(DISTINCT id)
FROM health.user_logs;

--Finding the top 10 customers by record 
SELECT 
    id,
    COUNT(*) AS row_count
FROM health.user_logs
GROUP BY id
ORDER BY row_count DESC
LIMIT 10;

--Inspecting the data where measure_value = 0
SELECT *
FROM health.user_logs
WHERE measure_value = 0;

--Dividing the data into groupd looking for anomalies
SELECT 
    measure,
    COUNT(*) AS record_count
FROM health.user_logs
WHERE measure_value = 0 
GROUP BY measure

-- Zero and Null values
SELECT COUNT(*) 
FROM health.user_logs
WHERE measure_value = 0 
    OR measure_value IS NULL;

-- CTE Unique values
--CTEs are suquentially executed statements that can be used in place of a subquery
--DONE IN MEMORY
WITH deduped_logs AS (
    SELECT DISTINCT *
    FROM health.user_logs
)
SELECT COUNT(*)
FROM deduped_logs;

--Subquery Unique values
-- The biggest difference is that subqueries are read from isnide out
--DONE IN MEMORY
SELECT COUNT(*)
FROM (
    SELECT DISTINCT *
    FROM health.user_logs
) AS subquery

-- Temporary table Unique values
--Sequential read/write to disk
DROP TABLE IF EXISTS deduplicarted_user_logs;

CREATE TEMP TABLE deduplicarted_user_logs
AS
  SELECT DISTINCT *
  FROM health.user_logs;

SELECT COUNT(*)
FROM deduplicarted_user_logs;

SELECT 
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic,
    COUNT(*) AS record_count
FROM health.user_logs
GROUP BY 
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic
ORDER BY record_count DESC;


--Trying to find duplicate with CTEs
WITH duplicate_data AS (
    SELECT 
        id,
        log_date,
        measure,
        measure_value,
        systolic,
        diastolic,
        COUNT(*) AS record_count
    FROM health.user_logs
    GROUP BY 
        id,
        log_date,
        measure,
        measure_value,
        systolic,
        diastolic
    ORDER BY record_count DESC
)

SELECT id, 
      SUM(record_count) AS total_count
FROM duplicate_data
GROUP BY id
ORDER BY total_count DESC;

--Filtering with a where clause

WITH duplicate_data AS (
    SELECT 
        id,
        log_date,
        measure,
        measure_value,
        systolic,
        diastolic,
        COUNT(*) AS record_count
    FROM health.user_logs
    GROUP BY 
        id,
        log_date,
        measure,
        measure_value,
        systolic,
        diastolic
)

SELECT id, 
      SUM(record_count) AS total_count
FROM duplicate_data
WHERE record_count > 1
GROUP BY id
ORDER BY total_count DESC;

--Filtering with a having clause

SELECT 
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic,
    COUNT(*) AS record_count
FROM health.user_logs
GROUP BY 
    id,
    log_date,
    measure,
    measure_value,
    systolic,
    diastolic
HAVING COUNT(*) > 1; --you cannot reference the alias in the having clause
