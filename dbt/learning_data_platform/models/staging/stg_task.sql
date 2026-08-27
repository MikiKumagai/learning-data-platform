-- BigQuery の task ソースを取り込む staging モデル。
-- 後続モデルで使いやすいように、主キー id を task_id として扱う。
SELECT
    id AS task_id,
    name AS task_name,
    progress_unit_id,
    progress_type_id,
    total_count,
    progress,
    active,
    is_wordbook
FROM {{ source('learning', 'task') }}
