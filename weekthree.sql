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