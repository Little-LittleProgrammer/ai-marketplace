---
name: qm-ai:status
description: Display current workflow status and progress
argument-hint: ""
allowed-tools:
  - Read
---

# 查看工作流状态

Display current workflow status and progress.

## Instructions

1. **Read State File**
   - Read `.qm-ai/state.json` if exists
   - If not exists, report no active workflow

2. **Check Output Files**
   - List files in `requirement/` directory
   - Map files to phases

3. **Generate Status Report**
   - Current phase
   - Started time
   - Completed outputs
   - Next steps

## Status Display Format

```
## 工作流状态

**当前阶段**: [Phase Name]
**开始时间**: [Started At]
**最后更新**: [Updated At]

### 已完成产物
- [x] spec-001.md (需求分析)
- [x] design-001.md (架构设计)
- [ ] task-001.md (待完成)

### 下一步
[What needs to happen next]

### 可用命令
- /qm-ai:continue - 进入下一阶段
- /qm-ai:rollback - 回滚到上一阶段
```

## Example Usage

```
User: /qm-ai:status

Response:
## 工作流状态

**当前阶段**: 架构设计
**开始时间**: 2026-03-16 10:00:00
**最后更新**: 2026-03-16 10:30:00

### 已完成产物
- [x] spec-001.md (需求分析)

### 下一步
完成设计文档后使用 /qm-ai:continue 进入任务分解阶段
```

## Error Handling

- **No active workflow**: Inform user to use /qm-ai:start
- **Invalid state file**: Report corruption and suggest restart