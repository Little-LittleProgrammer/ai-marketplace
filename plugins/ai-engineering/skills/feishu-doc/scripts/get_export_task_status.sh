#!/usr/bin/env bash
set -euo pipefail

# 获取导出任务状态
# 用法: get_export_task_status.sh <access_token> <ticket> <token>
if [ "$#" -lt 3 ]; then
  echo "用法: $0 <access_token> <ticket> <token>" >&2
  exit 1
fi

ACCESS_TOKEN="$1"
TICKET="$2"
FILE_TOKEN="$3"

curl -X GET "https://open.feishu.cn/open-apis/drive/v1/export_tasks/${TICKET}?token=${FILE_TOKEN}" \
-H "Authorization: Bearer ${ACCESS_TOKEN}"


# 返回数据格式
# {
#   "code": 0,
#   "data": {
#     "result": {
#       "extra": {
#         "_pod_name": "dp-35df76962f-6cbf7bccf9-7twlw"
#       },
#       "file_extension": "pdf",
#       "file_name": "“天工矩阵”计划",
#       "file_size": 601355,
#       "file_token": "T8r9bc79aoZYFzxJvpccVstjngf",
#       "job_error_msg": "success",
#       "job_status": 0,
#       "type": "docx"
#     }
#   },
#   "msg": "success"
# }
