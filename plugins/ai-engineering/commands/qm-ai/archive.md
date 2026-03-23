---
name: qm-ai:archive
description: Archive a completed requirement to context/requirement/archive/
argument-hint: <requirement-id> [requirement-name]
allowed-tools:
  - Read
  - Agent
  - Skill
---

# 归档需求

Use the **requirement-archive** skill to archive a completed requirement.

## Instructions

1. **Load requirement-archive skill**
   - Use the Skill tool to invoke `requirement-archive`

2. **Provide user feedback**
   - Show archive location and contents after completion

## 下一个可用命令

- `/qm-ai:continue` - 继续下一阶段的工作流
- `/qm-ai:status` - 查看当前的状态
- `/qm-ai:start` - 开始新的需求工作流
- `/qm-ai:knowledge` 或 `/qm-ai:optimize-flow` - 对归档的项目进行知识沉淀
