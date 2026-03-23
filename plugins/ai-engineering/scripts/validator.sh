#!/bin/bash
# Validator Script
# Validates plugin files and structure

set -e

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ERRORS=0
WARNINGS=0

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

error() {
    echo -e "${RED}ERROR: $1${NC}"
    ERRORS=$((ERRORS + 1))
}

warning() {
    echo -e "${YELLOW}WARNING: $1${NC}"
    WARNINGS=$((WARNINGS + 1))
}

success() {
    echo -e "${GREEN}OK: $1${NC}"
}

# Check required files
check_required_files() {
    echo "=== Checking Required Files ==="

    if [ -f "$PLUGIN_DIR/.claude-plugin/plugin.json" ]; then
        success "plugin.json exists"
    else
        error "plugin.json not found"
    fi

    if [ -x "$PLUGIN_DIR/scripts/session-end-persist.sh" ]; then
        success "session-end-persist.sh exists and is executable"
    else
        warning "session-end-persist.sh missing or not executable (SessionEnd hook)"
    fi

    if [ -d "$PLUGIN_DIR/agents" ]; then
        success "agents/ directory exists"
    else
        warning "agents/ directory not found"
    fi

    if [ -d "$PLUGIN_DIR/commands" ]; then
        success "commands/ directory exists"
    else
        warning "commands/ directory not found"
    fi

    if [ -d "$PLUGIN_DIR/skills" ]; then
        success "skills/ directory exists"
    else
        warning "skills/ directory not found"
    fi
}

# Check plugin.json format
check_plugin_json() {
    echo "=== Checking plugin.json ==="

    local json_file="$PLUGIN_DIR/.claude-plugin/plugin.json"

    if [ ! -f "$json_file" ]; then
        error "plugin.json not found"
        return
    fi

    # Check if valid JSON
    if python3 -c "import json; json.load(open('$json_file'))" 2>/dev/null; then
        success "plugin.json is valid JSON"
    else
        error "plugin.json is not valid JSON"
        return
    fi

    # Check required fields
    if grep -q '"name"' "$json_file"; then
        success "name field exists"
    else
        error "name field missing in plugin.json"
    fi
}

# Check agent files
check_agents() {
    echo "=== Checking Agents ==="

    local agent_count=0
    for file in "$PLUGIN_DIR/agents"/*.md; do
        if [ -f "$file" ]; then
            agent_count=$((agent_count + 1))
            local basename=$(basename "$file")

            # Check frontmatter
            if head -1 "$file" | grep -q "^---"; then
                success "$basename has frontmatter"
            else
                error "$basename missing frontmatter"
            fi

            # Check required fields
            if grep -q "^name:" "$file"; then
                success "$basename has name field"
            else
                error "$basename missing name field"
            fi

            if grep -q "^description:" "$file"; then
                success "$basename has description field"
            else
                error "$basename missing description field"
            fi
        fi
    done

    echo "Total agents: $agent_count"
}

# Check command files (supports commands/**/*.md e.g. commands/qm-ai/*.md)
check_commands() {
    echo "=== Checking Commands ==="

    local cmd_count=0
    while IFS= read -r -d '' file; do
        cmd_count=$((cmd_count + 1))
        local rel="${file#"$PLUGIN_DIR"/}"
        if head -1 "$file" | grep -q "^---"; then
            success "$rel has frontmatter"
        else
            error "$rel missing frontmatter"
        fi
    done < <(find "$PLUGIN_DIR/commands" -name "*.md" -type f -print0 2>/dev/null)

    echo "Total commands: $cmd_count"
}

# Check skill files
check_skills() {
    echo "=== Checking Skills ==="

    local skill_count=0
    for dir in "$PLUGIN_DIR/skills"/*/; do
        if [ -d "$dir" ]; then
            local skill_name=$(basename "$dir")
            local skill_file="$dir/SKILL.md"

            if [ -f "$skill_file" ]; then
                skill_count=$((skill_count + 1))
                success "$skill_name has SKILL.md"

                # Check frontmatter
                if head -1 "$skill_file" | grep -q "^---"; then
                    success "$skill_name SKILL.md has frontmatter"
                else
                    error "$skill_name SKILL.md missing frontmatter"
                fi
            else
                error "$skill_name missing SKILL.md"
            fi
        fi
    done

    echo "Total skills: $skill_count"
}

# Check workflow state consistency
check_workflow_state() {
    echo "=== Checking Workflow State ==="

    # Check state file structure
    if [ -f "$PLUGIN_DIR/../.qm-ai/state.json" ]; then
        success "state.json exists"

        # Validate state.json structure
        if python3 -c "
import json
import sys

required_keys = ['current_phase', 'updated_at']
optional_keys = ['started_at', 'requirement_id', 'requirement_path', 'outputs', 'rollback_history']

try:
    with open('$PLUGIN_DIR/../.qm-ai/state.json') as f:
        data = json.load(f)

    missing = [k for k in required_keys if k not in data]
    if missing:
        print(f'Missing required keys: {missing}')
        sys.exit(1)

    # Validate phase values
    valid_phases = ['IDLE', 'ANALYSIS', 'DESIGN', 'TASK', 'CODING', 'TESTING', 'COMPLETE']
    if data['current_phase'] not in valid_phases:
        print(f'Invalid phase: {data[\"current_phase\"]}')
        sys.exit(1)

    print('state.json structure valid')
except Exception as e:
    print(f'Error: {e}')
    sys.exit(1)
" 2>/dev/null; then
            success "state.json has valid structure"
        else
            error "state.json has invalid structure"
        fi
    else
        warning "state.json not found (may not be initialized yet)"
    fi
}

# Check agent references
check_agent_references() {
    echo "=== Checking Agent References ==="

    # Check if phase-router references all required agents
    local phase_router="$PLUGIN_DIR/agents/phase-router.md"
    if [ -f "$phase_router" ]; then
        local required_agents=("requirement-manager" "design-manager" "task-decomposer" "code-executor" "test-generator" "experience-depositor")
        local all_found=true

        for agent in "${required_agents[@]}"; do
            if grep -q "$agent" "$phase_router"; then
                success "phase-router references $agent"
            else
                warning "phase-router may not reference $agent"
                all_found=false
            fi
        done
    fi
}

# Check command allowed-tools
check_command_tools() {
    echo "=== Checking Command Allowed Tools ==="

    while IFS= read -r -d '' file; do
        local rel="${file#"$PLUGIN_DIR"/}"

        # Check if allowed-tools exists
        if grep -q "allowed-tools:" "$file"; then
            success "$rel has allowed-tools"
        else
            warning "$rel missing allowed-tools (will inherit default tools)"
        fi

        # Check if Agent tool is in allowed-tools when Agent is used
        if grep -q "Invoke:" "$file" || grep -q "Agent:" "$file"; then
            if grep -q "allowed-tools:" "$file" && ! grep -A5 "allowed-tools:" "$file" | grep -q "Agent"; then
                error "$rel invokes Agent but Agent not in allowed-tools"
            fi
        fi
    done < <(find "$PLUGIN_DIR/commands" -name "*.md" -type f -print0 2>/dev/null)
}

# Check skill references
check_skill_references() {
    echo "=== Checking Skill References ==="

    # Check if agents reference valid skills
    for agent_file in "$PLUGIN_DIR/agents"/*.md; do
        if [ -f "$agent_file" ]; then
            local basename=$(basename "$agent_file")

            # Extract skills mentioned
            grep -oE '\*\*[a-z-]+\*\*' "$agent_file" | tr -d '*' | while read -r skill; do
                if [ -d "$PLUGIN_DIR/skills/$skill" ]; then
                    success "$basename references valid skill: $skill"
                else
                    # Check if it's a skill name without directory
                    if [ "$skill" != "skill" ] && [ "$skill" != "skills" ]; then
                        warning "$basename references skill '$skill' - verify it exists"
                    fi
                fi
            done
        fi
    done
}

# Check hooks configuration
check_hooks() {
    echo "=== Checking Hooks ==="

    local hooks_file="$PLUGIN_DIR/hooks/hooks.json"
    if [ -f "$hooks_file" ]; then
        success "hooks.json exists"

        # Validate JSON
        if python3 -c "import json; json.load(open('$hooks_file'))" 2>/dev/null; then
            success "hooks.json is valid JSON"
        else
            error "hooks.json is not valid JSON"
        fi

        # Check if SessionEnd hook exists
        if grep -q "SessionEnd" "$hooks_file"; then
            success "SessionEnd hook configured"
        else
            warning "SessionEnd hook not found"
        fi
    else
        warning "hooks.json not found"
    fi
}

# Check workflow completeness
check_workflow_completeness() {
    echo "=== Checking Workflow Completeness ==="

    # Check for required skills
    local required_skills=("req-create" "design-create" "design-impl" "testing" "memory-system" "code-commit" "workspace-setup")
    for skill in "${required_skills[@]}"; do
        if [ -d "$PLUGIN_DIR/skills/$skill" ]; then
            success "Required skill exists: $skill"
        else
            error "Required skill missing: $skill"
        fi
    done

    # Check for new state-management skill
    if [ -d "$PLUGIN_DIR/skills/state-management" ]; then
        success "state-management skill exists (for state updates)"
    else
        warning "state-management skill not found (recommended for state updates)"
    fi
}

# Main
echo "QM-AI Workflow Plugin Validator"
echo "================================"
echo ""

check_required_files
echo ""

check_plugin_json
echo ""

check_agents
echo ""

check_commands
echo ""

check_skills
echo ""

check_workflow_state
echo ""

check_agent_references
echo ""

check_command_tools
echo ""

check_skill_references
echo ""

check_hooks
echo ""

check_workflow_completeness
echo ""

# Summary
echo "================================"
echo "Summary:"
echo "  Errors: $ERRORS"
echo "  Warnings: $WARNINGS"

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}Validation passed!${NC}"
    exit 0
else
    echo -e "${RED}Validation failed!${NC}"
    exit 1
fi