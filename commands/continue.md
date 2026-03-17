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

| Current Phase | Next Phase | Required Output | Next Agent |
|---------------|------------|-----------------|------------|
| ANALYSIS | DESIGN | spec.md | design-manager |
| DESIGN | TASK | design.md | task-decomposer |
| TASK | CODING | task.md | code-executor |
| CODING | TESTING | source code | test-generator |
| TESTING | COMPLETE | test code | experience-depositor |

## Agent Invocation

When transitioning phases, invoke the appropriate agent:

```markdown
### ANALYSIS → DESIGN
Invoke: design-manager
Message: "需求分析已完成，开始架构设计"

### DESIGN → TASK
Invoke: task-decomposer
Message: "设计已完成，开始任务分解"

### TASK → CODING
Invoke: code-executor
Message: "任务已分解，开始开发"

### CODING → TESTING
Invoke: test-generator
Message: "代码开发完成，开始测试"

### TESTING → COMPLETE
Invoke: experience-depositor
Message: "测试通过，开始知识沉淀"
```

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