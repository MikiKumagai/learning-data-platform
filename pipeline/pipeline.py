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

query = "SELECT * FROM progress"
df = pd.read_sql_query(query, conn)

conn.close()

# BigQueryへ
client = bigquery.Client(project=project_id)

table_id = f"{project_id}.{dataset}.progress"

job_config = bigquery.LoadJobConfig(
    write_disposition="WRITE_TRUNCATE",
)

job = client.load_table_from_dataframe(
    df,
    table_id,
    job_config=job_config,
)

job.result()

print("BigQueryへのロード完了")