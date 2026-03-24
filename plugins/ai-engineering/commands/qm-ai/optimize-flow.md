---
name: qm-ai:optimize-flow
description: Analyze workflow history and optimize processes, update knowledge base with best practices, and refine AGENTS.md with learned patterns
argument-hint: ""
allowed-tools:
  - Read
  - Agent
  - Skill
---

# 流程优化与知识沉淀

**别名**: 与 `/qm-ai:knowledge` 等价。

## Instructions

1. **Load required skills in order**
   - **experience-index**: Retrieve historical experiences from `AGENTS.md` and `context/`
   - **memory-system**: Validate knowledge deposition target structure
   - **agents-memory-maintainer**: Ensure AGENTS.md follows unified structure
   - **index-manage**: Execute consistency checks for `context/index.json`

2. **Analyze workflow**
   - Read `.qm-ai/state.json` and rollback history
   - Identify bottlenecks and patterns

3. **Update knowledge base**
   - Update `AGENTS.md`
   - Add patterns to `context/patterns/`
   - Document best practices in `context/best-practices/`
   - Record problems in `context/problems/`

4. **Provide optimization suggestions**
   - Phase sequence adjustments
   - Template improvements
   - Skill enhancements

## Skills to Load

| Priority | Skill | Purpose |
|----------|-------|---------|
| Required | `experience-index` | Historical experience retrieval |
| Required | `memory-system` | Knowledge structure validation |
| Required | `agents-memory-maintainer` | AGENTS.md maintenance |
| Required | `index-manage` | Index consistency check |
| Optional | `mate-maintainer` | Metadata maintenance |
| Optional | `requirement-complete` | Completion checklist reuse |

## 下一个可用命令

- `/qm-ai:status` - 查看优化后的工作流状态
- `/qm-ai:continue` - 基于优化建议继续工作流
- `/qm-ai:archive` - 如果项目已完成，进行归档
