#!/usr/bin/env bash
set -euo pipefail

# 获取文档信息
# 用法: get_docx_info.sh <access_token> <doc_token> <doc_type>
if [ "$#" -lt 3 ]; then
  echo "用法: $0 <access_token> <doc_token> <doc_type>" >&2
  exit 1
fi

ACCESS_TOKEN="$1"
DOC_TOKEN="$2"
DOC_TYPE="$3"

curl -X POST 'https://open.feishu.cn/open-apis/drive/v1/metas/batch_query?user_id_type=user_id' \
-H 'Content-Type: application/json' \
-H "Authorization: Bearer ${ACCESS_TOKEN}" \
-d "$(cat <<EOF
{
  "request_docs": [
    {
      "doc_token": "${DOC_TOKEN}",
      "doc_type": "${DOC_TYPE}"
    }
  ],
  "with_url": false
}
EOF
)"

# 返回数据格式
# {
#   "code": 0,
#   "data": {
#     "metas": [
#       {
#         "create_time": "1769394625",
#         "doc_token": "Vblod2vHrouQhIxq4KIc89xanrf",
#         "doc_type": "docx",
#         "latest_modify_time": "1769689372",
#         "latest_modify_user": "5912",
#         "owner_id": "5912",
#         "request_doc_info": {
#           "doc_token": "SjRrwH0CMilyzVkOYJ8cZBEjndf",
#           "doc_type": "wiki"
#         },
#         "sec_label_name": "",
#         "title": "“天工矩阵”计划",
#         "url": ""
#       }
#     ]
#   },
#   "msg": "Success"
# }
