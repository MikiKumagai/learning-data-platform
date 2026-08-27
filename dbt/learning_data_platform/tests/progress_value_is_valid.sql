SELECT *
FROM {{ ref('stg_progress') }}
WHERE progress_value < 0