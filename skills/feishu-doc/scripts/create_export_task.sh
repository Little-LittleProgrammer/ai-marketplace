#!/usr/bin/env bash
set -euo pipefail

# 创建导出任务
# 用法: create_export_task.sh <access_token> <sub_id> <token> <type> [file_extension]
if [ "$#" -lt 4 ]; then
  echo "用法: $0 <access_token> <sub_id> <token> <type> [file_extension]" >&2
  exit 1
fi

ACCESS_TOKEN="$1"
SUB_ID="$2"
FILE_TOKEN="$3"
FILE_TYPE="$4"
FILE_EXTENSION="${5:-docx}"

curl -X POST 'https://open.feishu.cn/open-apis/drive/v1/export_tasks' \
-H 'Content-Type: application/json' \
-H "Authorization: Bearer ${ACCESS_TOKEN}" \
-d "$(cat <<EOF
{
  "file_extension": "${FILE_EXTENSION}",
  "sub_id": "${SUB_ID}",
  "token": "${FILE_TOKEN}",
  "type": "${FILE_TYPE}"
}
EOF
)"

# 返回数据格式
# {
#   "code": 0,
#   "data": {
#     "ticket": "7600775125143112925"
#   },
#   "msg": "success"
# }
