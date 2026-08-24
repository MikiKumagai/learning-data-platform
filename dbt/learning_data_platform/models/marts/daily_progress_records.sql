-- 進捗が記録された日ごとの記録件数と累計進捗値を集計するマート。
-- daily_learning とは異なり、ここでは「その日に記録された累計値」を見る。
SELECT
    progress_date,
    COUNT(*) AS progress_count,
    SUM(progress_value) AS total_progress
FROM {{ ref('int_learning_progress') }}
GROUP BY progress_date
ORDER BY progress_date