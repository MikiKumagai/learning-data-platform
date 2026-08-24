-- BigQuery の progress ソースをそのまま扱いやすい名前で取り込む staging モデル。
-- タスクごとの進捗記録を表す。
SELECT
    task_id,
    progress_value,
    progress_date
FROM {{ source('learning', 'progress') }}
