CREATE TABLE enhanced_respiratory_visits (
    week_end DATE,
    pathogen VARCHAR(50),
    geography VARCHAR(50),
    percent_visits FLOAT,
    status VARCHAR(50),
    trend_on_date VARCHAR(50),
    recent_trend VARCHAR(50),
    month INT,
    year INT,
    age_group VARCHAR(50),
    gender VARCHAR(10),
    socio_economic_status VARCHAR(50),
    air_quality_index INT,
    temperature FLOAT,
    humidity FLOAT,
    mobility_index FLOAT,
    mask_compliance FLOAT,
    estimated_cost FLOAT
);


COPY enhanced_respiratory_visits FROM '/Users/muralidharreddykakanuru/Documents/tomcat/maven/virusdata.csv' DELIMITER ',' CSV HEADER;


select * from enhanced_respiratory_visits;


--State-wise Analysis
SELECT
    geography,
    AVG(percent_visits) AS avg_percent_visits
FROM
    enhanced_respiratory_visits
GROUP BY
    geography
ORDER BY
    avg_percent_visits DESC;


--Regional Hotspots

SELECT
    week_end,
    geography,
    AVG(percent_visits) AS avg_percent_visits
FROM
    enhanced_respiratory_visits
GROUP BY
    week_end, geography
ORDER BY
    week_end, geography;


--Trend Classification Significant Changes and Stable Periods

WITH ranked_visits AS (
    SELECT
        week_end,
        pathogen,
        geography,
        percent_visits,
        LAG(percent_visits) OVER (PARTITION BY geography, pathogen ORDER BY week_end) AS prev_percent_visits
    FROM
        enhanced_respiratory_visits
)
SELECT
    week_end,
    pathogen,
    geography,
    percent_visits,
    CASE
        WHEN percent_visits > prev_percent_visits THEN 'Increasing'
        WHEN percent_visits < prev_percent_visits THEN 'Decreasing'
        ELSE 'Stable'
    END AS trend
FROM
    ranked_visits;




-- Correlation and Relationship Analysis Inter-pathogen Correlations

SELECT
    rv1.pathogen AS pathogen1,
    rv2.pathogen AS pathogen2,
    rv1.geography,
    CORR(rv1.percent_visits, rv2.percent_visits) AS correlation
FROM
    enhanced_respiratory_visits rv1
JOIN
    enhanced_respiratory_visits rv2
ON
    rv1.week_end = rv2.week_end
    AND rv1.geography = rv2.geography
    AND rv1.pathogen <> rv2.pathogen
GROUP BY
    rv1.pathogen, rv2.pathogen, rv1.geography;





--Cross-State Comparisons

--This query compares the average percentage of ED visits for each pathogen across states.sql



SELECT
    geography,
    pathogen,
    AVG(percent_visits) AS avg_percent_visits
FROM
    enhanced_respiratory_visits
GROUP BY
    geography, pathogen
ORDER BY
    geography, pathogen;






--seasonal pattrens:
SELECT
    month,
    pathogen,
    AVG(percent_visits) AS avg_percent_visits
FROM
    enhanced_respiratory_visits
GROUP BY
    month, pathogen
ORDER BY
    month, pathogen;




--Demographic Analysis
SELECT
    age_group,
    gender,
    socio_economic_status,
    pathogen,
    AVG(percent_visits) AS avg_percent_visits
FROM
    enhanced_respiratory_visits
GROUP BY
    age_group, gender, socio_economic_status, pathogen
ORDER BY
    age_group, gender, socio_economic_status, pathogen;



--Health Utilization
SELECT
    week_end,
    SUM(percent_visits) AS total_percent_visits
FROM
    enhanced_respiratory_visits
GROUP BY
    week_end
ORDER BY
    week_end;



--Environmental Factor

SELECT
    air_quality_index,
    temperature,
    humidity,
    pathogen,
    AVG(percent_visits) AS avg_percent_visits
FROM
    enhanced_respiratory_visits
GROUP BY
    air_quality_index, temperature, humidity, pathogen
ORDER BY
    air_quality_index, temperature, humidity, pathogen;


--Behavioral Insights
SELECT
    mobility_index,
    mask_compliance,
    pathogen,
    AVG(percent_visits) AS avg_percent_visits
FROM
    enhanced_respiratory_visits
GROUP BY
    mobility_index, mask_compliance, pathogen
ORDER BY
    mobility_index, mask_compliance, pathogen;

--Econamic Impact Analysis
SELECT
    week_end,
    pathogen,
    SUM(estimated_cost) AS total_estimated_cost
FROM
    enhanced_respiratory_visits
GROUP BY
    week_end, pathogen
ORDER BY
    week_end, pathogen;





SELECT
    year,
    pathogen,
    AVG(percent_visits) AS avg_percent_visits
FROM
    enhanced_respiratory_visits
GROUP BY
    year, pathogen
ORDER BY
    year, pathogen;


