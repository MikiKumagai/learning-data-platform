-- 全タスク合計の日別学習量に、直近7日間の移動平均を付与するマート。
-- 日ごとのブレをならして、学習ペースのトレンドを見やすくする。
{{ config(materialized='table') }}

SELECT
    dl.progress_date,
    dl.daily_learning,
    AVG(dl.daily_learning) OVER (
        ORDER BY dl.progress_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS seven_day_average
FROM {{ ref('daily_learning') }} AS dl
ORDER BY dl.progress_date
