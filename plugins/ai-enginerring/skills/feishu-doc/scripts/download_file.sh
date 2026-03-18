#!/usr/bin/env bash
set -euo pipefail

# 下载文件
# 用法: download_file.sh <access_token> <file_token> <output_path>
if [ "$#" -lt 3 ]; then
  echo "用法: $0 <access_token> <file_token> <output_path>" >&2
  exit 1
fi

ACCESS_TOKEN="$1"
FILE_TOKEN="$2"
OUTPUT_PATH="$3"

curl -X GET "https://open.feishu.cn/open-apis/drive/v1/export_tasks/file/${FILE_TOKEN}/download" \
-H "Authorization: Bearer ${ACCESS_TOKEN}" \
--output "${OUTPUT_PATH}"
