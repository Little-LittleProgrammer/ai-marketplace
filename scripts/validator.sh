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

# Check command files
check_commands() {
    echo "=== Checking Commands ==="

    local cmd_count=0
    for file in "$PLUGIN_DIR/commands"/*.md; do
        if [ -f "$file" ]; then
            cmd_count=$((cmd_count + 1))
            local basename=$(basename "$file")

            # Check frontmatter
            if head -1 "$file" | grep -q "^---"; then
                success "$basename has frontmatter"
            else
                error "$basename missing frontmatter"
            fi
        fi
    done

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