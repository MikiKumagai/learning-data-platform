-- BigQuery の progress_unit ソースを取り込む staging モデル。
-- ページ・問・章など、進捗の単位を表すマスタ。
SELECT
    id,
    name
FROM {{ source('learning', 'progress_unit') }}
