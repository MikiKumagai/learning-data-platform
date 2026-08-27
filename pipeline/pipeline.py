import os
import sqlite3

import pandas as pd
from dotenv import load_dotenv
from google.cloud import bigquery

load_dotenv()

db_path = os.getenv("SQLITE_DB_PATH")
project_id = os.getenv("GCP_PROJECT_ID")
dataset = os.getenv("BQ_DATASET")

# SQLiteから読み込み
conn = sqlite3.connect(db_path)

query = "SELECT * FROM progresses"

df = pd.read_sql_query(query, conn)

df["progress_date"] = pd.to_datetime(
    df["progress_date"]
).dt.date

conn.close()

# BigQueryへ
client = bigquery.Client(project=project_id)

table_id = f"{project_id}.{dataset}.progress"

job_config = bigquery.LoadJobConfig(
    schema=[
        bigquery.SchemaField("id", "INT64"),
        bigquery.SchemaField("task_id", "INT64"),
        bigquery.SchemaField("progress_value", "INT64"),
        bigquery.SchemaField("progress_date", "DATE"),
    ],
    write_disposition="WRITE_TRUNCATE",
)

job = client.load_table_from_dataframe(
    df,
    table_id,
    job_config=job_config,
)

job.result()

print("BigQueryへのロード完了")

from pathlib import Path
import subprocess

PROJECT_DIR = Path(__file__).resolve().parent.parent
DBT_DIR = PROJECT_DIR / "dbt" / "learning_data_platform"

result = subprocess.run(
    ["dbt", "run"],
    cwd=DBT_DIR,
    capture_output=True,
    text=True,
)

print(result.stdout)
print(result.stderr)