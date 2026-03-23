---
name: qm-ai:start
description: Start the QM-AI workflow with a requirement description or document link
argument-hint: <requirement description or document URL>
allowed-tools:
  - Read
  - Write
  - Agent
  - Skill
---

# 启动工作流

Execute the QM-AI workflow startup process.

## Instructions

1. **Check Initial State**
   - Read `.qm-ai/state.json` if exists
   - If a workflow is already in progress, ask user whether to continue or start fresh

2. **Analyze User Input**
   - If input contains URL (feishu.cn, etc.): Load and use the `feishu-doc` skill to fetch document content
   - If input is a brief description: Load and use the `explore` skill to expand requirements
   - If input is detailed requirements: Proceed directly to requirement analysis

3. **Initialize Workflow State**
   - Create `.qm-ai/state.json` with initial state:
   ```json
   {
     "current_phase": "ANALYSIS",
     "started_at": "<timestamp>",
     "updated_at": "<timestamp>",
     "input_type": "<url|brief|detailed>",
     "outputs": {}
   }
   ```

4. **Route to Agent**
   - Use the Agent tool to invoke `phase-router`
   - Pass the analyzed input context

5. **Provide User Feedback**
   - Display workflow status
   - Show what will happen next
   - Explain how to use `/qm-ai:continue` to proceed

## Input Type Detection

### URL Pattern
- Regex: `https?://[^\s]+`
- Action: Trigger feishu-doc skill

### Brief Description Pattern
- Short text (< 100 characters)
- Lacks specific details
- Action: Trigger explore skill

### Detailed Requirements Pattern
- Comprehensive description
- Contains specific features, constraints
- Action: Direct to requirement-manager

## Example Usage

```
User: /qm-ai:start 帮我开发一个用户认证系统

Response:
## 工作流已启动

**输入类型**: 简短描述
**当前阶段**: 需求分析
**下一步**: explore skill 将帮助扩展需求细节

[proceeds with explore skill]
```

## Error Handling

- **Missing input**: Prompt user to provide requirement description
- **Invalid URL**: Report error and ask for valid input
- **Workflow in progress**: Ask to continue or restart