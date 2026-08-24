-- 全タスクの1日あたり学習量を日付ごとに集計するマート。
-- 学習量の推移や曜日別傾向を見るための基本テーブル。
SELECT
    progress_date,
    SUM(daily_progress) AS daily_learning
FROM {{ ref('int_daily_progress') }}
GROUP BY progress_date
ORDER BY progress_date