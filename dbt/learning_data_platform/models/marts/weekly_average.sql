-- 全タスク合計の日別学習量に、直近7日間の移動平均を付与するマート。
-- 日ごとのブレをならして、学習ペースのトレンドを見やすくする。
{{ config(materialized='table') }}

SELECT
    progress_date,
    daily_learning,
    AVG(daily_learning) OVER (
        ORDER BY progress_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS seven_day_average
FROM {{ ref('daily_learning') }}
ORDER BY progress_date