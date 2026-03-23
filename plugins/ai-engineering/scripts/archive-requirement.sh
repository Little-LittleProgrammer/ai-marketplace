#!/usr/bin/env bash
# Archive Requirement Script
# Archives a requirement to context/requirement/archive/RE-xxx-需求名称/
# Usage: ./archive-requirement.sh <requirement-id> [requirement-name]

set -euo pipefail

REQUIREMENT_DIR="context/requirement"
ARCHIVE_DIR="${REQUIREMENT_DIR}/archive"
INDEX_FILE="${REQUIREMENT_DIR}/index.json"
TEMPLATE_FILE="${REQUIREMENT_DIR}/archive/index.json"

# Ensure directories exist
mkdir -p "${ARCHIVE_DIR}"

# Get next RE number
get_next_re_number() {
    local max_num=0

    if [ -f "$INDEX_FILE" ]; then
        # Parse JSON to find max RE number
        max_num=$(grep -o '"id": *"RE-[0-9]*"' "$INDEX_FILE" 2>/dev/null | \
            grep -o '[0-9]*$' | sort -n | tail -1 || echo "0")
    fi

    if [ -f "$TEMPLATE_FILE" ]; then
        # Also check archive index
        archive_max=$(grep -o '"id": *"RE-[0-9]*"' "$TEMPLATE_FILE" 2>/dev/null | \
            grep -o '[0-9]*$' | sort -n | tail -1 || echo "0")
        [ "$archive_max" -gt "$max_num" ] && max_num="$archive_max"
    fi

    next_num=$((max_num + 1))
    printf "%03d" "$next_num"
}

# Validate requirement exists in index
requirement_exists() {
    local req_id=$1
    if [ -f "$INDEX_FILE" ]; then
        grep -q "\"id\": *\"${req_id}\"" "$INDEX_FILE" 2>/dev/null
    else
        return 1
    fi
}

# Get requirement name from index
get_requirement_name() {
    local req_id=$1
    if [ -f "$INDEX_FILE" ]; then
        python3 -c "
import json
with open('${INDEX_FILE}', 'r', encoding='utf-8') as f:
    data = json.load(f)
    for req in data.get('requirements', []):
        if req.get('id') == '${req_id}':
            print(req.get('name', ''))
            break
" 2>/dev/null || echo ""
    fi
}

# Create archive directory for requirement
create_archive_dir() {
    local re_num=$1
    local req_name=$2

    # Sanitize name for directory (replace special chars)
    local sanitized_name=$(echo "$req_name" | sed 's/[^a-zA-Z0-9\u4e00-\u9fa5]/-/g' | sed 's/-\+/-/g' | sed 's/^-\+//' | sed 's/-\+$//')
    local archive_path="${ARCHIVE_DIR}/RE-${re_num}-${sanitized_name}"

    mkdir -p "$archive_path"
    echo "$archive_path"
}

# Update archive index
update_archive_index() {
    local re_num=$1
    local req_name=$2
    local spec_file=$3
    local design_file=$4
    local task_file=$5
    local completed_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Initialize archive index if not exists
    if [ ! -f "$TEMPLATE_FILE" ]; then
        mkdir -p "$(dirname "$TEMPLATE_FILE")"
        echo '{"requirements": []}' > "$TEMPLATE_FILE"
    fi

    # Use Python for proper JSON handling
    python3 << PY
import json
import sys

index_file = "${TEMPLATE_FILE}"
re_num = "${re_num}"
req_name = """${req_name}"""
spec = """${spec_file}"""
design = """${design_file}"""
task = """${task_file}"""
completed_at = "${completed_at}"

try:
    with open(index_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
except (OSError, json.JSONDecodeError):
    data = {"requirements": []}

# Check if already archived
already_exists = any(r.get('id') == f'RE-{re_num}' for r in data.get('requirements', []))
if already_exists:
    print(f"Requirement RE-{re_num} already archived")
    sys.exit(0)

new_entry = {
    "id": f"RE-{re_num}",
    "name": req_name,
    "spec": spec,
    "design": design,
    "task": task,
    "archived_at": completed_at,
    "status": "archived"
}

data.setdefault('requirements', []).append(new_entry)

with open(index_file, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write('\n')

print(f"Archive index updated for RE-{re_num}")
PY
}

# Main
main() {
    local req_id=${1:-}
    local req_name=${2:-}

    if [ -z "$req_id" ]; then
        echo "Usage: $0 <requirement-id> [requirement-name]"
        echo "Example: $0 RE-001 用户认证系统"
        exit 1
    fi

    echo "=== Requirement Archive Process ==="
    echo "Requirement ID: $req_id"

    # If req_name not provided, try to get from index
    if [ -z "$req_name" ]; then
        req_name=$(get_requirement_name "$req_id")
        if [ -z "$req_name" ]; then
            echo "Error: Cannot find requirement name. Please provide as second argument."
            exit 1
        fi
    fi
    echo "Requirement Name: $req_name"

    # Get next RE number (for auto-archive mode)
    if [ "$req_id" = "AUTO" ]; then
        req_id="RE-$(get_next_re_number)"
        echo "Auto-generated ID: $req_id"
    fi

    # Validate requirement exists
    if ! requirement_exists "$req_id"; then
        echo "Warning: Requirement $req_id not found in index"
    fi

    # Create archive directory
    archive_path=$(create_archive_dir "$(echo "$req_id" | grep -o '[0-9]*')" "$req_name")
    echo "Archive directory: $archive_path"

    # Find and move related files
    local spec_file=""
    local design_file=""
    local task_file=""

    # Look for spec, design, task files in requirement dir
    if [ -d "$REQUIREMENT_DIR" ]; then
        # Find files matching the requirement
        spec_file=$(find "$REQUIREMENT_DIR" -maxdepth 1 -name "*spec*" -type f 2>/dev/null | head -1 || echo "")
        design_file=$(find "$REQUIREMENT_DIR" -maxdepth 1 -name "*design*" -type f 2>/dev/null | head -1 || echo "")
        task_file=$(find "$REQUIREMENT_DIR" -maxdepth 1 -name "*task*" -type f 2>/dev/null | head -1 || echo "")

        # Move files to archive
        [ -n "$spec_file" ] && [ -f "$spec_file" ] && mv "$spec_file" "$archive_path/" && echo "Moved: $spec_file"
        [ -n "$design_file" ] && [ -f "$design_file" ] && mv "$design_file" "$archive_path/" && echo "Moved: $design_file"
        [ -n "$task_file" ] && [ -f "$task_file" ] && mv "$task_file" "$archive_path/" && echo "Moved: $task_file"
    fi

    # Create archive manifest
    cat > "${archive_path}/archive-manifest.json" << EOF
{
  "id": "${req_id}",
  "name": "${req_name}",
  "archived_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "spec": "$(basename "$spec_file" 2>/dev/null || echo "")",
  "design": "$(basename "$design_file" 2>/dev/null || echo "")",
  "task": "$(basename "$task_file" 2>/dev/null || echo "")"
}
EOF

    # Update archive index
    update_archive_index "$(echo "$req_id" | grep -o '[0-9]*')" "$req_name" \
        "$(basename "$spec_file" 2>/dev/null || echo "")" \
        "$(basename "$design_file" 2>/dev/null || echo "")" \
        "$(basename "$task_file" 2>/dev/null || echo "")"

    echo ""
    echo "=== Archive Complete ==="
    echo "Archived to: $archive_path"
}

main "$@"
