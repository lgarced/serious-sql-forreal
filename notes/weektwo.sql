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
