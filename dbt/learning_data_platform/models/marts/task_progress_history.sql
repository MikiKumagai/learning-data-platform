-- タスクごとの日別学習履歴に、開始からの日数と累積学習日数を付与するマート。
-- 将来的に「このペースなら30日後にどれくらい進むか」を予測するための土台にする。
-- 進捗記録がない日は daily_progress = 0 として補完し、休止期間も分析対象に含める。
WITH daily_progress_by_date AS (
    SELECT
        task_id,
        task_name,
        progress_date,
        SUM(daily_progress) AS daily_progress
    FROM {{ ref('int_daily_progress') }}
    GROUP BY task_id, task_name, progress_date
),

task_date_range AS (
    SELECT
        task_id,
        task_name,
        MIN(progress_date) AS first_progress_date,
        MAX(progress_date) AS latest_progress_date
    FROM daily_progress_by_date
    GROUP BY task_id, task_name
),

task_calendar AS (
    SELECT
        task_id,
        task_name,
        progress_date,
        DATE_DIFF(
            progress_date,
            first_progress_date,
            DAY
        ) AS days_since_start
    FROM task_date_range,
        UNNEST(GENERATE_DATE_ARRAY(first_progress_date, latest_progress_date)) AS progress_date
),

progress_history AS (
    SELECT
        c.task_id,
        c.task_name,
        c.progress_date,
        COALESCE(p.daily_progress, 0) AS daily_progress,
        c.days_since_start,
        COUNTIF(COALESCE(p.daily_progress, 0) > 0) OVER (
            PARTITION BY c.task_id
            ORDER BY c.progress_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_learning_days
    FROM task_calendar AS c
    LEFT JOIN daily_progress_by_date AS p
        ON c.task_id = p.task_id
        AND c.progress_date = p.progress_date
)

SELECT
    task_id,
    task_name,
    progress_date,
    daily_progress,
    days_since_start,
    cumulative_learning_days
FROM progress_history
ORDER BY task_id, progress_date
