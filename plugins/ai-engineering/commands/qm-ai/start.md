---
name: qm-ai:start
description: Start the QM-AI workflow with a requirement description or document link
argument-hint: <requirement description or document URL>
allowed-tools:
  - Read
  - Write
  - Bash
  - Agent
  - Skill
---

# 启动工作流

Execute the QM-AI workflow startup process.

## Instructions

1. **Check Initial State**
   - Read `.qm-ai/state.json` if exists
   - If workflow already in progress, ask user to continue or start fresh

2. **Setup Requirement Directory**
   - Create `context/requirement/RE-xxx-需求名称/` directory
   - Update `context/requirement/index.json` with new requirement entry

3. **Initialize Workflow State**
   - Create `.qm-ai/state.json` with requirement_id, requirement_path, current_phase: "ANALYSIS"

4. **Route to phase-router Agent**
   - Pass analyzed input context including requirement_id and requirement_path

5. **Provide User Feedback**
   - Display requirement ID and directory
   - Show next step (explore skill or feishu-doc skill based on input type)

## Input Routing

| Input Type | Skill to Load |
|------------|---------------|
| URL (feishu.cn, etc.) | `feishu-doc` |
| Brief description | `explore` |
| Detailed requirements | Direct to requirement-manager agent |

## 下一个可用命令

- `/qm-ai:status` - 查看当前工作流状态
- `/qm-ai:init` - 如果是新项目，先进行冷启动初始化
- `/qm-ai:continue` - 开始需求分析后，进入下一阶段
