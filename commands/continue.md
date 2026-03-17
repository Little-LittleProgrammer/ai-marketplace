---
name: continue
description: Confirm current phase output and proceed to the next workflow phase
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Edit
  - Agent
---

# 继续下一阶段

Confirm current phase and transition to the next workflow phase.

## Instructions

1. **Verify Current State**
   - Read `.qm-ai/state.json`
   - Confirm current phase and outputs

2. **Validate Current Output**
   - Check that required output files exist
   - Verify output completeness

3. **Update State**
   - Transition to next phase
   - Update `state.json`:
   ```json
   {
     "current_phase": "<next_phase>",
     "updated_at": "<timestamp>",
     "outputs": {
       "<phase>": ["<output_files>"]
     }
   }
   ```

4. **Invoke Next Agent**
   - Use Agent tool to invoke appropriate agent for next phase

## Phase Transitions

| Current Phase | Next Phase | Required Output |
|---------------|------------|-----------------|
| ANALYSIS | DESIGN | spec.md |
| DESIGN | TASK | design.md |
| TASK | CODING | task.md |
| CODING | TESTING | source code |
| TESTING | COMPLETE | test code |

## Example Usage

```
User: /qm-ai:continue

Response:
## 阶段确认

**上一阶段**: 需求分析
**当前阶段**: 架构设计
**产物**: spec-001.md

准备调用 design-manager 进行架构设计...
```

## Error Handling

- **Missing output**: Report missing files and ask user to complete
- **Invalid state**: Report state error and suggest recovery
- **Already complete**: Inform user workflow is finished