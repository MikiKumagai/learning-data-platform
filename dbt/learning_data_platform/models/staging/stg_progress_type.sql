-- BigQuery の progress_type ソースを取り込む staging モデル。
-- 進捗値が累計なのか差分なのか、といった進捗形式のマスタ。
SELECT
    id,
    name
FROM {{ source('learning', 'progress_type') }}
