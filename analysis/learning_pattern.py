import pandas as pd
# ② 学習ペースの分類

# BigQueryに接続・SQLを実行するための道具
from google.cloud import bigquery
# 取得したデータをPythonで扱うための道具
import pandas as pd

client = bigquery.Client(
    project="learning-data-platform-505213"
)

query = """
SELECT *
FROM `learning-data-platform-505213.learning.task_learning_features`
"""

# BigQueryにSQLを送る
# BigQueryの結果をpandasのDataFrameにする
df = client.query(query).to_dataframe()

print(df)