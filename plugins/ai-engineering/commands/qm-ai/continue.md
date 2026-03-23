---
name: qm-ai:continue
description: Confirm current phase outputs and delegate next-phase routing to phase-router
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Edit
  - Agent
---

# 继续下一阶段

Confirm current phase outputs and hand off routing decision.

## Instructions

1. **Verify Current State**
   - Read `.qm-ai/state.json`
   - Confirm current phase and outputs

2. **Validate Current Output**
   - Check that required output files exist
   - Verify output completeness

3. **Update State**
   - Sync validation results and latest outputs
   - Do not determine or hardcode next phase in this command
   - Update `state.json`:
   ```json
   {
     "current_phase": "<keep_current_phase>",
     "updated_at": "<timestamp>",
     "outputs": {
       "<phase>": ["<output_files>"]
     }
   }
   ```

4. **Invoke Router Agent**
   - Always use Agent tool to invoke `phase-router`
   - Provide current phase and available outputs as routing context
   - Let `phase-router` decide which specific agent and skill should execute next

## Routing Principle

- Do not define fixed phase transitions in `/continue`
- Do not hardcode next agent or next skill in `/continue`
- Always delegate phase decision and dispatching to `phase-router`

## Agent Invocation

Always invoke `phase-router` with current context:

```markdown
Invoke: phase-router
Message: "当前阶段与产物已校验完成。请基于 `.qm-ai/state.json` 和现有产物，判断应进入的下一阶段，并路由到合适的 agent 和 skill。"
```

## Example Usage

```
User: /qm-ai:continue

Response:
## 阶段确认

**上一阶段**: 需求分析
**产物**: spec-001.md

准备调用 phase-router 进行统一路由派发...
```

## Error Handling

- **Missing output**: Report missing files and ask user to complete
- **Invalid state**: Report state error and suggest recovery
- **Already complete**: Inform user workflow is finished