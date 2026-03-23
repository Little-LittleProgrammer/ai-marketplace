#!/bin/bash
# State Manager Script
# Manages workflow state file operations

set -e

STATE_FILE=".qm-ai/state.json"
REQUIREMENT_DIR="requirement"

# Initialize state file
init_state() {
    mkdir -p .qm-ai
    cat > "$STATE_FILE" << EOF
{
  "current_phase": "IDLE",
  "started_at": null,
  "updated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "input_type": null,
  "outputs": {},
  "rollback_history": []
}
EOF
    echo "State file initialized"
}

# Get current phase
get_phase() {
    if [ -f "$STATE_FILE" ]; then
        grep -o '"current_phase": *"[^"]*"' "$STATE_FILE" | cut -d'"' -f4
    else
        echo "IDLE"
    fi
}

# Update phase
update_phase() {
    local new_phase=$1
    if [ -f "$STATE_FILE" ]; then
        # Use sed to update the phase
        sed -i.bak "s/\"current_phase\": *\"[^\"]*\"/\"current_phase\": \"$new_phase\"/" "$STATE_FILE"
        sed -i.bak "s/\"updated_at\": *\"[^\"]*\"/\"updated_at\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"/" "$STATE_FILE"
        rm -f "${STATE_FILE}.bak"
        echo "Phase updated to: $new_phase"
    fi
}

# Add output
add_output() {
    local phase=$1
    local file=$2
    echo "Adding output: $file for phase: $phase"
    # Note: Complex JSON updates should be done via the agent
}

# Main
case "$1" in
    init)
        init_state
        ;;
    get-phase)
        get_phase
        ;;
    update-phase)
        update_phase "$2"
        ;;
    add-output)
        add_output "$2" "$3"
        ;;
    *)
        echo "Usage: $0 {init|get-phase|update-phase|add-output}"
        exit 1
        ;;
esac