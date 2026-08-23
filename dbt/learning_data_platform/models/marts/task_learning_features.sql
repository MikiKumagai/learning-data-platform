-- 「自分が伸びやすい学習ペース」を見つける
-- TODO: int_daily_progress を使う

SELECT
  i.task_id,
  i.task_name,
  total_progress,
  avg_daily_progress,
  learning_days,
  active_rate,
  max_daily_progress,
  progress_stddev
FROM {{ ref('int_daily_progress') }} AS i
