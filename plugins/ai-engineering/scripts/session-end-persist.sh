#!/usr/bin/env bash
# SessionEnd hook: bump .qm-ai/state.json updated_at in the project cwd (hook stdin provides cwd).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

read_hook_cwd() {
	if [ -t 0 ]; then
		echo ""
		return 0
	fi
	python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get('cwd') or '', end='')
except Exception:
    pass
" 2>/dev/null || true
}

HOOK_CWD="$(read_hook_cwd)"
TARGET="${HOOK_CWD:-${PWD:-.}}"
STATE_FILE="${TARGET%/}/.qm-ai/state.json"

if [[ ! -f "$STATE_FILE" ]]; then
	exit 0
fi

python3 << PY
import json
from datetime import datetime, timezone

path = r"""$STATE_FILE"""
try:
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
except (OSError, json.JSONDecodeError):
    raise SystemExit(0)

data["updated_at"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
PY
