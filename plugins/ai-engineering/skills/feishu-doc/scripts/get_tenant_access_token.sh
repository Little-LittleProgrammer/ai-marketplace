#!/usr/bin/env bash
set -euo pipefail

# 获取飞书租户访问令牌
# 用法: get_tenant_access_token.sh <app_id> <app_secret>
if [ "$#" -lt 2 ]; then
  echo "用法: $0 <app_id> <app_secret>" >&2
  exit 1
fi

FEISHU_APP_ID="$1"
FEISHU_APP_SECRET="$2"

curl -X POST 'https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal' \
-H 'Content-Type: application/json' \
-d "$(cat <<EOF
{
  "app_id": "${FEISHU_APP_ID}",
  "app_secret": "${FEISHU_APP_SECRET}"
}
EOF
)"

# 返回数据格式
# {
#   "code": 0,
#   "expire": 5337,
#   "msg": "ok",
#   "tenant_access_token": "t-g1041u9IY7Z5FCMUJJMCQJMZ7MEP7HNDIE5R73FF"
# }
