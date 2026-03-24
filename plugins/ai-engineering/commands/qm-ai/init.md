---
name: qm-ai:init
description: Initialize the project by analyzing existing code and generating or updating AGENTS.md with project knowledge summary
argument-hint: ""
allowed-tools:
  - Read
  - Glob
  - Grep
  - Agent
  - Skill
---

# 冷启动初始化

Analyze existing project structure and generate or update AGENTS.md.

## Instructions

1. **Load required skills**
   - **memory-system**: Validate memory structure specification
   - **service-overview**: Establish service boundaries and directory structure
   - **agents-memory-maintainer**: Enforce AGENTS.md structure quality
   - **index-manage**: Check and repair index consistency

2. **Analyze project**
   - Scan directory structure with Glob
   - Identify technology stack (Node.js/Python/Go/etc.)
   - Detect frameworks and databases

3. **Generate AGENTS.md**
   - Project overview
   - Technology stack
   - Architecture summary
   - Code patterns
   - Best practices

4. **Update context knowledge**
   - Initialize `context/index.json`
   - Create `context/patterns/`, `context/best-practices/` if needed

## Skills to Load

| Priority | Skill | Purpose |
|----------|-------|---------|
| Required | `memory-system` | Structure validation |
| Required | `service-overview` | Service boundary analysis |
| As needed | `service-architecture` | Architecture style extraction |
| As needed | `service-business` | Business logic identification |
| As needed | `service-ops` | API contract mapping |
| Required | `agents-memory-maintainer` | AGENTS.md structure |
| Required | `index-manage` | Index consistency |

## 下一个可用命令

- `/qm-ai:start` - 完成初始化后，启动新的需求工作流
- `/qm-ai:status` - 查看当前项目状态
