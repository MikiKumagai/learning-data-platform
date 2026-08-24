-- タスク単位で学習ペースの特徴量を集計するマート。
-- 後続の分析や機械学習で「進みやすいタスク」「継続しやすいタスク」を見るために使う。
-- task_progress_history で休止日を 0 として補完しているため、平均やばらつきに休止期間も反映される。
WITH task_features AS (
    SELECT
        task_id,
        task_name,
        MIN(progress_date) AS first_progress_date,
        MAX(progress_date) AS latest_progress_date,
        SUM(daily_progress) AS total_progress,
        AVG(daily_progress) AS avg_daily_progress,
        COUNTIF(daily_progress > 0) AS learning_days,
        SAFE_DIVIDE(COUNTIF(daily_progress > 0), COUNT(*)) AS active_rate,
        MAX(daily_progress) AS max_daily_progress,
        STDDEV_POP(daily_progress) AS progress_stddev
    FROM {{ ref('task_progress_history') }}
    GROUP BY task_id, task_name
)

SELECT
    task_id,
    task_name,
    first_progress_date,
    latest_progress_date,
    total_progress,
    avg_daily_progress,
    learning_days,
    active_rate,
    max_daily_progress,
    progress_stddev
FROM task_features
