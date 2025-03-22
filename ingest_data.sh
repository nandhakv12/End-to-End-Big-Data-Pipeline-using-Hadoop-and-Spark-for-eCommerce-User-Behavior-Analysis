#!/bin/bash

# === Variables ===
CONTAINER_NAME=cse587project-namenode-1
LOCAL_FILE_PATH="./2019-Oct.csv"
HDFS_DIR="/ecommerce_data"
HDFS_FILE_NAME="2019-Oct.csv"
CONTAINER_DEST_PATH="/opt/hadoop/$HDFS_FILE_NAME"

echo "🚀 Starting Data Ingestion Script..."

# === Step 1: Copy file into the Namenode container ===
echo "📦 Copying $LOCAL_FILE_PATH into container $CONTAINER_NAME..."
docker cp "$LOCAL_FILE_PATH" "$CONTAINER_NAME:$CONTAINER_DEST_PATH"

# === Step 2: Run HDFS commands inside the container ===
echo "🏗️  Creating directory and uploading file to HDFS..."
docker exec -it "$CONTAINER_NAME" bash -c "
  hdfs dfs -mkdir -p $HDFS_DIR &&
  hdfs dfs -put -f $CONTAINER_DEST_PATH $HDFS_DIR/
"

# === Step 3: Verify the file is in HDFS ===
echo "🔍 Verifying file in HDFS..."
docker exec -it "$CONTAINER_NAME" hdfs dfs -ls "$HDFS_DIR"

echo "✅ Data Ingestion Completed!"
