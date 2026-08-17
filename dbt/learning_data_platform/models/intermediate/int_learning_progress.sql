SELECT
    p.task_id,
    t.task_name,
    t.total_count,
    p.progress_value,
    p.progress_date,
    pu.name AS progress_unit
FROM {{ ref('stg_progress') }} AS p -- dbtで作った stg_progress というモデルを使う
JOIN {{ ref('stg_task') }} AS t
    ON p.task_id = t.task_id
JOIN {{ ref('stg_progress_unit') }} AS pu
    ON t.progress_unit_id = pu.id