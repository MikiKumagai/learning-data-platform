SELECT
    progress_date,
    SUM(daily_progress) AS daily_learning
FROM {{ ref('int_daily_progress') }}
GROUP BY progress_date
ORDER BY progress_date