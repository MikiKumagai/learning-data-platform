-- 進捗ログにタスク名・総量・進捗単位を付与した、分析の土台になる中間モデル。
-- staging 層の生データを結合し、marts 層から扱いやすい形に整える。
SELECT
    p.task_id,
    t.task_name,
    t.total_count,
    p.progress_value,
    p.progress_date,
    pu.name AS progress_unit
FROM {{ ref('stg_progress') }} AS p
INNER JOIN {{ ref('stg_task') }} AS t
    ON p.task_id = t.task_id
INNER JOIN {{ ref('stg_progress_unit') }} AS pu
    ON t.progress_unit_id = pu.id
