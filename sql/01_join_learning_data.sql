SELECT
    p.task_id,
    t.name AS task_name,
    p.progress_value,
    p.progress_date,
    pt.name AS progress_type,
    pu.name AS progress_unit
FROM `learning-data-platform-505213.learning.progress` AS p
JOIN `learning-data-platform-505213.learning.task` AS t
    ON p.task_id = t.id
JOIN `learning-data-platform-505213.learning.progress_type` AS pt
    ON t.progress_type_id = pt.id
JOIN `learning-data-platform-505213.learning.progress_unit` AS pu
    ON t.progress_unit_id = pu.id
ORDER BY p.progress_date;