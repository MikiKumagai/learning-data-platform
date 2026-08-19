{{ config(materialized='table') }}

SELECT
    progress_date,
    daily_progress,
    AVG(daily_progress) OVER (
        ORDER BY progress_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS seven_day_average
FROM {{ ref('daily_learning') }}
ORDER BY progress_date