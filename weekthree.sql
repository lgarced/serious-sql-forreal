--STATISTICS 101:
--Mean/Averrage arithmetic mean
--Median [50th percentile] middle value
--Mode most common value

--AVERAGE
SELECT
    measure,
    AVG(measure_value)
FROM health.user_logs
GROUP BY measure;

--Min and Max functions
SELECT 
    MIN(measure_value) AS MinimumWeight,
    MAX(measure_value) AS MaximumWeight
FROM health.user_logs
WHERE measure = 'weight'

--Trying to get the range with a CTE
--If data has not been cleaned, this will not work as expected
--For results to be accurate, the data must be cleaned
WITH cte_weight_range AS (
      SELECT 
          MIN(measure_value) AS MinimumWeight,
          MAX(measure_value) AS MaximumWeight
      FROM health.user_logs
      WHERE measure = 'weight'
)

SELECT 
    *,
    MaximumWeight -  MinimumWeight AS weight_range
FROM cte_weight_range

--Finding bad data and trying to filter it out
SELECT measure_value
FROM health.user_logs
WHERE measure = 'weight'
ORDER BY 1 
LIMIT 100;

--More statistics functions 
WITH cte_summary_statistics AS (
      SELECT 
          MIN(measure_value) AS MinimumWeight,
          MAX(measure_value) AS MaximumWeight,
          AVG(measure_value) AS AverageWeight,
          PERCENTILE_CONT(0.5) WITHIN GROUP
              (ORDER BY measure_value) AS MedianWeight,
          MODE () WITHIN GROUP 
              (ORDER BY measure_value) AS ModeWeight,      
          VARIANCE(measure_value) AS VarienceWeight,
          STDDEV(measure_value) AS StddevWeight
      FROM health.user_logs
      WHERE measure = 'weight'
        AND measure_value BETWEEN 1 AND 201
)

SELECT 
    *,
    MaximumWeight -  MinimumWeight AS weight_range
FROM cte_summary_statistics

