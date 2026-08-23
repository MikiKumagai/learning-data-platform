-- 「30日後の自分の進捗」を予測する

-- TODO: int_daily_progress を使う
-- TODO: 休止期間は「0」として扱う

SELECT
  i.task_id,
  i.task_name,
  i.progress_date,
  i.daily_progress,
  days_since_start,
  cumulative_learning_days
FROM {{ ref('int_daily_progress') }} AS i
