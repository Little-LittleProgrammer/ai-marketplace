#!/usr/bin/env bash
# Requirement Setup Script
# Creates directory structure for new requirement at context/requirement/RE-xxx-需求名称/
# Usage: ./requirement-setup.sh <requirement-name>

set -euo pipefail

REQUIREMENT_DIR="context/requirement"
INDEX_FILE="${REQUIREMENT_DIR}/index.json"

# Ensure base directory exists
mkdir -p "${REQUIREMENT_DIR}"

# Get next RE number for active requirements
get_next_re_number() {
    local max_num=0

    if [ -f "$INDEX_FILE" ]; then
        # Parse JSON to find max RE number
        max_num=$(grep -o '"id": *"RE-[0-9]*"' "$INDEX_FILE" 2>/dev/null | \
            grep -o '[0-9]*$' | sort -n | tail -1 || echo "0")
    fi

    next_num=$((max_num + 1))
    printf "%03d" "$next_num"
}

# Initialize index file if not exists
init_index() {
    if [ ! -f "$INDEX_FILE" ]; then
        mkdir -p "$(dirname "$INDEX_FILE")"
        echo '{"requirements": []}' > "$INDEX_FILE"
    fi
}

# Create requirement directory
create_requirement_dir() {
    local re_num=$1
    local req_name=$2

    # Sanitize name for directory
    local sanitized_name=$(echo "$req_name" | sed 's/[^a-zA-Z0-9\u4e00-\u9fa5]/-/g' | sed 's/-\+/-/g' | sed 's/^-\+//' | sed 's/-\+$//')
    local req_path="${REQUIREMENT_DIR}/RE-${re_num}-${sanitized_name}"

    mkdir -p "$req_path"
    echo "$req_path"
}

# Update index with new requirement
update_index() {
    local re_num=$1
    local req_name=$2
    local req_path=$3
    local started_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    python3 << PY
import json

index_file = "${INDEX_FILE}"
re_num = "${re_num}"
req_name = """${req_name}"""
req_path = """${req_path}"""
started_at = "${started_at}"

try:
    with open(index_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
except (OSError, json.JSONDecodeError):
    data = {"requirements": []}

new_entry = {
    "id": f"RE-{re_num}",
    "name": req_name,
    "path": req_path,
    "started_at": started_at,
    "status": "in_progress",
    "current_phase": "ANALYSIS",
    "outputs": {}
}

data.setdefault('requirements', []).append(new_entry)

with open(index_file, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write('\n')

print(f"Index updated: RE-{re_num}")
PY
}

# Main
main() {
    local req_name=${1:-}

    if [ -z "$req_name" ]; then
        echo "Usage: $0 <requirement-name>"
        echo "Example: $0 用户认证系统"
        exit 1
    fi

    echo "=== Requirement Setup ==="
    echo "Requirement Name: $req_name"

    # Initialize index
    init_index

    # Get next RE number
    re_num=$(get_next_re_number)
    echo "Assigned ID: RE-${re_num}"

    # Create directory
    req_path=$(create_requirement_dir "$re_num" "$req_name")
    echo "Directory created: $req_path"

    # Update index
    update_index "$re_num" "$req_name" "$req_path"

    # Output for consumption
    echo ""
    echo "RE_NUM=$re_num"
    echo "RE_PATH=$req_path"
}

main "$@"
