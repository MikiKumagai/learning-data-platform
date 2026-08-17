SELECT
    id,
    name
FROM {{ source('learning', 'progress_type') }}