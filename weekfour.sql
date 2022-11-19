--Week four notes

--Stats summary
SELECT
    ROUND(MIN(measure_value), 2 ) AS MinimumValue,
    ROUND(MAX(measure_value), 2) AS MaximumValue,
    ROUND(AVG(measure_value), 2) AS MeanValue,
    ROUND(
      --This function actually returns a float which is incompatible with round
      --We use the cast function to convert the output type to NUMERIC
      CAST(PERCENTILE_CONT(0.5) WITHIN GROUP
          (ORDER BY measure_value) AS NUMERIC),
          2
    ) AS MedianValue,
    ROUND (
      MODE() WITHIN GROUP (ORDER BY measure_value),
      2
    ) AS ModeValue,
    ROUND(STDDEV(measure_value), 2) AS StandardDeviation,
    ROUND(VARIANCE(measure_value), 2) AS VarianceValue
FROM health.user_logs
WHERE measure = 'weight';


--- Data Algorithm
  -- 1. Sort values ascending
  -- 2. Assign  1-100 percentile value
  -- 3. For each percentile aggregate :
  --    a. Calculate floor & ceiling values
  --    b. Calculate record count

--NTILE function
SELECT
    measure_value,
    NTILE(100) OVER (
      ORDER BY
       measure_value
      ) AS percentile
FROM health.user_logs
WHERE measure = 'weight'


--Calculate floor & ceiling values and aggregates
WITH percentile_value AS (
    SELECT
      measure_value,
      NTILE(100) OVER(
        ORDER BY
          measure_value
      ) AS percentile 
    FROM health.user_logs
    WHERE measure = 'weight'
)

SELECT 
  percentile,
  MIN(measure_value) AS floor_value,
  MAX(measure_value) AS ceiling_value,
  COUNT(*) AS percentile_counts
FROM percentile_value  
GROUP BY percentile
ORDER BY percentile;