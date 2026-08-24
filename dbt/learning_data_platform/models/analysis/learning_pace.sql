-- タスクごとの学習ペースを比較するための分析用モデル。
-- task_progress_history を使い、休止日を含めた日別学習量から集計する。
SELECT
    task_name,
    COUNTIF(daily_progress > 0) AS learning_days,
    SUM(daily_progress) AS total_progress,
    AVG(daily_progress) AS avg_daily_progress,
    MAX(daily_progress) AS max_daily_progress
FROM {{ ref('task_progress_history') }}
GROUP BY task_name
ORDER BY avg_daily_progress DESC
