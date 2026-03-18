#!/bin/bash
# Template Generator Script
# Generates document templates for requirements, designs, and tasks

set -e

REQUIREMENT_DIR="requirement"

# Generate spec template
generate_spec() {
    local id=$1
    local title=${2:-"未命名需求"}
    local file="$REQUIREMENT_DIR/spec-${id}.md"

    mkdir -p "$REQUIREMENT_DIR"

    cat > "$file" << EOF
# 需求规格：${title}

## 概述

[在此填写需求概述]

## 功能需求

### 功能点1

- **描述**:
- **验收标准**:

## 非功能需求

- **性能**:
- **安全**:
- **可用性**:

## 边界约束

[在此填写技术约束和业务约束]

## 用户故事

作为 [角色]，我希望 [功能]，以便 [价值]。

## 附录

[补充信息]
EOF

    echo "Generated: $file"
}

# Generate design template
generate_design() {
    local id=$1
    local title=${2:-"未命名设计"}
    local file="$REQUIREMENT_DIR/design-${id}.md"

    mkdir -p "$REQUIREMENT_DIR"

    cat > "$file" << EOF
# 架构设计：${title}

## 系统架构

[架构图和组件说明]

### 组件列表

| 组件 | 职责 | 技术栈 |
|------|------|--------|
| | | |

## API 设计

### 接口1

- **路径**: \`/api/v1/resource\`
- **方法**: GET/POST/PUT/DELETE
- **请求**:
\`\`\`json
{}
\`\`\`
- **响应**:
\`\`\`json
{}
\`\`\`

## 数据模型

### 表结构

\`\`\`sql
CREATE TABLE example (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
\`\`\`

## 技术选型

| 类别 | 选择 | 理由 |
|------|------|------|
| | | |

## 安全设计

[安全考虑和措施]

## 附录

[补充信息]
EOF

    echo "Generated: $file"
}

# Generate task template
generate_task() {
    local id=$1
    local title=${2:-"未命名任务"}
    local file="$REQUIREMENT_DIR/task-${id}.md"

    mkdir -p "$REQUIREMENT_DIR"

    cat > "$file" << EOF
# 任务分解：${title}

## 任务列表

### 任务1: [任务名称]

- **描述**:
- **依赖**: 无
- **优先级**: 高/中/低
- **预估工时**:
- **负责人**:

## 依赖关系

\`\`\`
[任务依赖关系图]
\`\`\`

## 里程碑

| 里程碑 | 预计完成 | 状态 |
|--------|----------|------|
| | | |

## 风险项

| 风险 | 影响 | 缓解措施 |
|------|------|----------|
| | | |

## 附录

[补充信息]
EOF

    echo "Generated: $file"
}

# Main
case "$1" in
    spec)
        generate_spec "$2" "$3"
        ;;
    design)
        generate_design "$2" "$3"
        ;;
    task)
        generate_task "$2" "$3"
        ;;
    *)
        echo "Usage: $0 {spec|design|task} <id> [title]"
        exit 1
        ;;
esac