---
name: qm-ai:rollback
description: Rollback to the previous workflow phase, preserving current outputs
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Agent
---

# 回滚到上一阶段

Rollback to the previous workflow phase while preserving current outputs.

## Instructions

1. **Verify Current State**
   - Read `.qm-ai/state.json`
   - Confirm current phase

2. **Determine Previous Phase**
   - Map current phase to previous phase
   - Record rollback in history

3. **Update State**
   - Set phase to previous
   - Add rollback record:
   ```json
   {
     "current_phase": "<previous_phase>",
     "updated_at": "<timestamp>",
     "rollback_history": [
       {
         "from": "<current>",
         "to": "<previous>",
         "timestamp": "<timestamp>"
       }
     ]
   }
   ```

4. **Inform User**
   - Show rollback result
   - Indicate what outputs are preserved

## Rollback Rules

| Current Phase | Rollback To | Preserved |
|---------------|-------------|-----------|
| ANALYSIS | IDLE | - |
| DESIGN | ANALYSIS | spec.md |
| TASK | DESIGN | design.md |
| CODING | TASK | task.md |
| TESTING | CODING | source code |

## Example Usage

```
User: /qm-ai:rollback

Response:
## 回滚成功

**从**: 架构设计
**到**: 需求分析
**保留产物**: spec-001.md

可以重新进行架构设计。
```

## 下一个可用命令

- `/qm-ai:status` - 回滚后查看当前状态
- `/qm-ai:continue` - 重新尝试进入目标阶段

## Error Handling

- **Already at IDLE**: Cannot rollback from IDLE state
- **Invalid state**: Report state error