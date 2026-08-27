SELECT *
FROM {{ ref('stg_progress') }}
WHERE progress_date > CURRENT_DATE()