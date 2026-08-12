-- 進捗率が100%を超えているデータ
SELECT *
FROM `learning-data-platform-505213.learning.task_progress_summary`
WHERE progress_rate > 1;

-- 進捗率がマイナスになっていないか
SELECT *
FROM `learning-data-platform-505213.learning.task_progress_summary`
WHERE progress_rate < 0;

-- 必須項目がNULLになっていないか
SELECT *
FROM `learning-data-platform-505213.learning.task_progress_summary`
WHERE task_name IS NULL
   OR progress_rate IS NULL
   OR progress_date IS NULL
   OR progress_unit IS NULL;