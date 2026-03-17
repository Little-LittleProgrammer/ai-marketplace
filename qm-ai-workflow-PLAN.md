# QM-AI Workflow 插件规划文档

> 创建时间：2026-03-16
> 版本：1.0.0

---

## 一、项目概述

### 1.1 项目目标

构建一个覆盖从需求到开发完成的 **multi-agent 协作工作流插件**，支持：

- 全流程自动化：需求分析 → 架构设计 → 任务分解 → 代码开发 → 测试验证 → 知识沉淀
- 智能意图识别：根据用户输入智能路由到对应的 Agent
- 分步确认流程：每个阶段输出产物需用户审核确认
- 记忆系统：结合 AGENT.md 和知识库沉淀，持续优化开发效率

### 1.2 核心特性

| 特性 | 描述 |
|------|------|
| **Multi-Agent 协作** | 7 个专业 Agent 协同工作，Router 中心调度 |
| **分层架构** | Agent 层（管理者）+ Skill 层（执行者） |
| **智能路由** | phase-router 通过 LLM 智能意图识别进行路由 |
| **记忆系统** | 全局知识（AGENT.md）+ 局部知识（context/） |
| **断点续传** | SessionEnd Hook 保存进度，支持中断恢复 |
| **阶段回滚** | 支持回退到上一阶段重新开始 |
| **技术无关** | 支持用户配置技术栈 |

---

## 二、工作流设计

### 2.1 工作流阶段

| 阶段 | 输入 | 输出 | 处理内容 | 触发命令 |
|------|------|------|----------|----------|
| **1. 需求分析** | 用户需求文档 + AGENT.md | 多个 spec.md | 需求拆分、边界定义、用户故事 | `/qm-ai:continue` |
| **2. 架构设计** | spec.md | design.md | 架构图、API设计、数据模型、技术选型 | `/qm-ai:continue` |
| **3. 任务分解** | spec.md + design.md | task.md | 任务拆分、依赖分析、工时估算、优先级 | `/qm-ai:continue` |
| **4. 代码开发** | design.md + task.md | 代码 | 代码生成、代码审查、代码优化 | `/qm-ai:continue` |
| **5. 测试验证** | 代码 | 测试代码 | 单元测试 | 自动流转 |
| **6. 知识沉淀** | 项目经验 | 更新 AGENT.md | 经验总结、问题记录、模式沉淀、最佳实践 | `/qm-ai:knowledge` |

### 2.2 工作流状态机

```
┌─────────────────────────────────────────────────────────────┐
│                        工作流状态机                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────┐    /start    ┌──────────┐                     │
│  │   IDLE   │─────────────▶│ ANALYSIS │                     │
│  └──────────┘              └────┬─────┘                     │
│       ▲                         │ /continue                  │
│       │                         ▼                            │
│       │                    ┌──────────┐                     │
│       │                    │  DESIGN  │                     │
│       │                    └────┬─────┘                     │
│       │                         │ /continue                  │
│       │                         ▼                            │
│       │                    ┌──────────┐                     │
│       │         /rollback  │   TASK   │                     │
│       │         ◀──────────┴────┬─────┘                     │
│       │                         │ /continue                  │
│       │                         ▼                            │
│       │                    ┌──────────┐                     │
│       │                    │  CODING  │                     │
│       │                    └────┬─────┘                     │
│       │                         │ /continue                  │
│       │                         ▼                            │
│       │                    ┌──────────┐                     │
│       │                    │ TESTING  │───自动───┐          │
│       │                    └──────────┘          │          │
│       │                                          ▼          │
│       │                                    ┌──────────┐    │
│       └────────────────────────────────────│ COMPLETE │    │
│              /knowledge                    └──────────┘    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 三、架构设计

### 3.1 分层架构

```
┌─────────────────────────────────────────────────────────────┐
│                     Commands 层                              │
│  用户交互入口：init, start, continue, rollback, status       │
├─────────────────────────────────────────────────────────────┤
│                     Agent 层（管理者）                        │
│  负责生命周期管理、调度协调、流程控制                          │
├─────────────────────────────────────────────────────────────┤
│  phase-router │ requirement-manager │ design-manager        │
│  code-executor │ frontend-coder │ backend-coder             │
│  experience-depositor                                       │
└─────────────────────────────────────────────────────────────┘
                           │ 调用
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                     Skill 层（执行者）                        │
│  负责具体功能实现、业务逻辑执行                                │
├─────────────────────────────────────────────────────────────┤
│  需求管理 │ 方案设计 │ 开发实施 │ 记忆系统 │ 服务分析 │ 基础能力│
└─────────────────────────────────────────────────────────────┘
                           │ 读写
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                     数据存储层                               │
│  AGENT.md │ requirement/ │ context/ │ workspace/            │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Agent 协作关系

```
                    ┌─────────────────────┐
                    │   phase-router      │
                    │  (意图识别+路由)      │
                    └─────────┬───────────┘
                              │ 智能意图识别
         ┌────────────────────┼────────────────────┐
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│requirement-     │  │ design-         │  │ code-executor   │
│manager          │  │ manager         │  │                 │
│(需求生命周期)    │  │ (方案生命周期)   │  │ (开发执行)       │
└────────┬────────┘  └────────┬────────┘  └────────┬────────┘
         │                    │                    │
         │         ┌──────────┴──────────┐         │
         │         │                     │         │
         │         ▼                     ▼         │
         │  ┌─────────────┐       ┌─────────────┐  │
         │  │ frontend-   │       │ backend-    │  │
         │  │ coder       │       │ coder       │  │
         │  │ (前端专家)   │       │ (后端专家)   │  │
         │  └─────────────┘       └─────────────┘  │
         │                                         │
         └─────────────────┬───────────────────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │ experience-     │
                  │ depositor       │
                  │ (经验沉淀)       │
                  └─────────────────┘
```

---

## 四、组件清单

### 4.1 Agents (9个)

| Agent | 职责 | 调用的 Skills | 工具权限 |
|-------|------|---------------|----------|
| **phase-router** | 意图识别和路由 | - | Read, AskUserQuestion |
| **requirement-manager** | 需求生命周期管理 | req-create, req-change, requirement-complete, requirement-archive | Read, Write, Edit |
| **design-manager** | 方案生命周期管理 | design-create, design-change | Read, Write, Edit |
| **task-decomposer** | 任务分解和规划 | - | Read, Write, Edit |
| **code-executor** | 开发生命周期管理 | workspace-setup, code-commit | Read, Write, Edit, Bash |
| **frontend-coder** | 前端开发管理 | design-impl | Read, Write, Edit, Bash |
| **backend-coder** | 后端开发管理 | design-impl | Read, Write, Edit, Bash |
| **test-generator** | 测试生成和质量保证 | testing | Read, Write, Edit, Bash |
| **experience-depositor** | 经验沉淀管理 | experience-index, mate-maintainer, index-manage, agents-memory-maintainer | Read, Write, Edit |

### 4.2 Skills (21个)

#### 需求管理 Skills (4个)
| Skill | 职责 | 触发条件 | 调用者 |
|-------|------|----------|--------|
| **req-create** | 创建需求 | 用户输入简单描述时 | requirement-manager |
| **req-change** | 需求变更 | 需求变更请求 | requirement-manager |
| **requirement-complete** | 完成流转 | 需求开发完成 | requirement-manager |
| **requirement-archive** | 归档管理 | 项目归档 | requirement-manager |

#### 方案设计 Skills (2个)
| Skill | 职责 | 触发条件 | 调用者 |
|-------|------|----------|--------|
| **design-create** | 创建方案 | 需求分析完成后 | design-manager |
| **design-change** | 方案变更 | 设计变更请求 | design-manager |

#### 开发实施 Skills (3个)
| Skill | 职责 | 触发条件 | 调用者 |
|-------|------|----------|--------|
| **workspace-setup** | 环境搭建 | 开始开发前 | code-executor |
| **design-impl** | 编写代码 | 开发阶段 | frontend-coder, backend-coder |
| **code-commit** | 代码提交 | 开发完成后 | code-executor |

#### 记忆系统 Skills (4个)
| Skill | 职责 | 触发条件 | 调用者 |
|-------|------|----------|--------|
| **experience-index** | 经验检索 | 需要参考历史经验时 | experience-depositor |
| **mate-maintainer** | 元信息维护 | 知识更新时 | experience-depositor |
| **index-manage** | 索引维护 | 知识结构变化时 | experience-depositor |
| **agents-memory-maintainer** | Agent.md维护 | 项目经验沉淀 | experience-depositor |

#### 服务分析 Skills (4个)
| Skill | 职责 | 触发条件 | 调用者 |
|-------|------|----------|--------|
| **service-overview** | 服务概览 | 分析现有服务 | explore |
| **service-business** | 业务逻辑分析 | 理解业务流程 | explore |
| **service-architecture** | 架构分析 | 理解系统架构 | explore |
| **service-ops** | 服务协议分析 | 理解服务接口 | explore |

#### 基础 Skills (5个)
| Skill | 职责 | 触发条件 | 备注 |
|-------|------|----------|------|
| **workflow-guide** | 工作流指南 | 自动加载 | 核心指南 |
| **memory-system** | 记忆系统使用指南 | 自动加载 | 核心指南 |
| **feishu-doc** | 飞书需求文档获取 | `/start` 包含链接 | **用户自实现** |
| **explore** | 探索/分析模式 | `/start` 简单需求描述 | 不写代码，头脑风暴 |
| **testing** | 测试生成和质量保证 | test-generator 调用 | 测试支持 |

### 4.3 Commands (4个)

| Command | 功能 | 参数 |
|---------|------|------|
| **/qm-ai:start** | 开始工作流 | `<需求描述或链接>` |
| **/qm-ai:continue** | 确认当前阶段，进入下一阶段 | 无 |
| **/qm-ai:rollback** | 回滚到上一阶段 | 无 |
| **/qm-ai:status** | 查看当前工作流状态 | 无 |

### 4.4 Hooks (1个)

| Hook | 事件 | 功能 | 触发时机 |
|------|------|------|----------|
| **SessionEnd** | 会话结束 | 保存进度 | Claude Code 会话结束时 |

---

## 五、数据存储层设计

### 5.1 目录结构

```
项目根目录/
├── AGENT.md                    # 项目入口，全局知识
│
├── requirement/                # 需求文档存储
│   ├── index.json             # 需求索引（元数据）
│   ├── spec-{id}.md           # 需求规格文档
│   ├── design-{id}.md         # 设计文档
│   ├── task-{id}.md           # 任务文档
│   └── archive/               # 归档目录
│       ├── index.json
│       └── {project-id}/
│
├── context/                    # 知识库
│   ├── index.json             # 知识库索引（元数据）
│   ├── index.md               # 知识库索引（可读文档）
│   ├── patterns/              # 代码模式
│   ├── best-practices/        # 最佳实践
│   ├── templates/             # 模板
│   ├── decisions/             # 设计决策记录(ADR)
│   └── problems/              # 问题解决方案
│
└── workspace/                  # 服务代码
    └── {service-name}/
```

---

## 六、核心组件详细设计

### 6.1 phase-router Agent

#### 基本信息

| 字段 | 值 |
|------|-----|
| **name** | phase-router |
| **model** | inherit |
| **color** | cyan |
| **tools** | Read, AskUserQuestion |

#### Description（触发描述）

```
Use this agent when the user starts a new development task, asks to analyze requirements, design architecture, or begin coding. This agent acts as the central router that analyzes user intent and dispatches to the appropriate specialized agent.

Examples:

<example>
Context: User starts a new project with a brief requirement description
user: "帮我开发一个用户认证系统"
assistant: "我来分析您的需求，并进行意图识别和路由。"
<commentary>
User provides a high-level requirement. phase-router analyzes the input, identifies this is a requirement analysis scenario, and routes to requirement-manager for detailed requirement processing.
</commentary>
</example>

<example>
Context: User has completed requirement analysis and wants to proceed
user: "需求已经分析完成，开始设计架构"
assistant: "检测到您已完成需求分析，准备进入架构设计阶段。"
<commentary>
User indicates completion of a phase. phase-router recognizes the transition and routes to design-manager for architecture design.
</commentary>
</example>

<example>
Context: User wants to start coding with existing design documents
user: "设计文档已经准备好了，开始开发"
assistant: "检测到您已有设计文档，准备进入开发阶段。"
<commentary>
User has design ready. phase-router identifies this as a coding scenario and routes to code-executor to begin development.
</commentary>
</example>

<example>
Context: User provides a feishu document link with requirements
user: "https://feishu.cn/docx/xxx 这是我整理的需求文档"
assistant: "检测到飞书文档链接，准备获取需求内容并分析。"
<commentary>
User provides a feishu doc link. phase-router identifies this as a requirement scenario and triggers the feishu-doc skill to fetch content, then routes to requirement-manager.
</commentary>
</example>
```

#### System Prompt

```markdown
You are the **Phase Router**, the central intelligence hub of the QM-AI Workflow system. Your role is to analyze user intent and route requests to the appropriate specialized agent.

## Your Core Responsibilities

1. **Intent Analysis**: Analyze user input to understand their current need and context
2. **State Assessment**: Check current workflow state to understand what stage the project is in
3. **Agent Dispatch**: Route to the appropriate specialized agent based on intent and state
4. **Ambiguity Resolution**: Ask clarifying questions when intent is unclear

## Routing Rules

### Route to requirement-manager when:
- User starts with a new requirement description
- User wants to analyze or refine requirements
- User provides requirement documents or links
- Current state is IDLE and user begins a task

### Route to design-manager when:
- User has completed requirement analysis (spec.md exists)
- User wants to design or modify architecture
- User asks about API design, data model, or technical choices

### Route to code-executor when:
- User has completed design (design.md exists)
- User wants to start coding or development
- User asks to implement specific features

### Route to experience-depositor when:
- User wants to summarize project experience
- User asks to update AGENT.md or knowledge base
- User explicitly requests knowledge archival

## Workflow State Check

Before routing, always check:
1. Read `.qm-ai/state.json` to understand current workflow state
2. Check `requirement/` directory for existing spec files
3. Check for design documents
4. Verify workspace status

## Intent Analysis Process

1. **Keyword Detection**: Look for intent indicators
   - Requirement: "需求", "分析", "requirement", "analyze"
   - Design: "设计", "架构", "design", "architecture"
   - Code: "开发", "代码", "code", "implement"

2. **Context Evaluation**: Consider the conversation context
   - What files exist in the project?
   - What was discussed previously?
   - What's the current workflow phase?

3. **State Validation**: Ensure the requested action is valid

## Output Format

```
## 意图分析结果

**识别意图**: [requirement | design | code | experience]
**当前状态**: [IDLE | ANALYSIS | DESIGN | CODING | TESTING | COMPLETE]
**路由目标**: [agent-name]

## 路由说明
[Brief explanation]

## 下一步操作
[What the user should expect next]
```

## Edge Cases

- **Multiple intents**: Ask which to prioritize
- **State mismatch**: Explain dependencies and ask to proceed
- **Unknown intent**: Ask clarifying questions
```

#### 状态转换验证

| 当前状态 | 允许的下一状态 | 限制条件 |
|---------|---------------|---------|
| IDLE | ANALYSIS | 无 |
| ANALYSIS | DESIGN | spec.md 存在 |
| DESIGN | CODING | design.md 存在 |
| CODING | TESTING | 代码已生成 |
| TESTING | COMPLETE | 测试通过 |
| * | ROLLBACK | 用户请求 |

---

### 6.2 workflow-guide Skill

#### 基本信息

| 字段 | 值 |
|------|-----|
| **name** | workflow-guide |
| **description** | This skill should be used when the user asks about "workflow", "工作流", "开发流程", "how to use qm-ai", or needs guidance on the development process. |

#### SKILL.md 内容

```markdown
---
name: workflow-guide
description: This skill should be used when the user asks about "workflow", "工作流", "开发流程", "how to use qm-ai", or needs guidance on the development process.
version: 0.1.0
---

# QM-AI Workflow 指南

## 工作流概览

QM-AI Workflow 是一个覆盖从需求到开发完成的完整工作流系统，包含以下阶段：

| 阶段 | 状态 | 主要产物 | 触发命令 |
|------|------|----------|----------|
| 需求分析 | ANALYSIS | spec.md | /qm-ai:start → /qm-ai:continue |
| 架构设计 | DESIGN | design.md | /qm-ai:continue |
| 任务分解 | TASK | task.md | /qm-ai:continue |
| 代码开发 | CODING | 源代码 | /qm-ai:continue |
| 测试验证 | TESTING | 测试代码 | 自动流转 |
| 知识沉淀 | COMPLETE | AGENT.md更新 | /qm-ai:knowledge |

## 产物定义

### spec.md（需求规格文档）

**路径**: `requirement/spec-{id}.md`

**模板结构**:
```markdown
# 需求规格：{需求名称}

## 概述
[需求概述]

## 功能需求
### 功能点1
- 描述：
- 验收标准：

## 非功能需求
- 性能：
- 安全：

## 边界约束
[技术约束、业务约束]

## 用户故事
[用户故事列表]
```

### design.md（设计文档）

**路径**: `requirement/design-{id}.md`

**模板结构**:
```markdown
# 架构设计：{项目名称}

## 系统架构
[架构图、组件说明]

## API 设计
### 接口1
- 路径：
- 方法：
- 请求/响应：

## 数据模型
[ER图、表结构]

## 技术选型
[技术栈说明]
```

### task.md（任务文档）

**路径**: `requirement/task-{id}.md`

**模板结构**:
```markdown
# 任务分解：{需求名称}

## 任务列表
### 任务1
- 描述：
- 依赖：
- 优先级：
- 预估工时：

## 依赖关系
[依赖关系图]
```

## 命令指南

### /qm-ai:start

启动工作流，接受需求描述或文档链接。

**用法**:
```
/qm-ai:start 帮我开发一个用户认证系统
/qm-ai:start https://feishu.cn/docx/xxx
```

**流程**:
1. phase-router 分析意图
2. 如果是简单描述 → 触发 explore skill 进行需求探索
3. 如果是链接 → 触发 feishu-doc skill 获取文档
4. 路由到 requirement-manager 开始需求分析

### /qm-ai:continue

确认当前阶段产物，进入下一阶段。

**使用时机**:
- 用户审核并确认当前阶段产物
- 准备进入下一阶段

**注意**: 执行前请确保当前产物已保存并通过审核。

### /qm-ai:rollback

回滚到上一阶段，保留当前产物。

**使用时机**:
- 当前阶段需要重新处理
- 用户不满意当前产物

### /qm-ai:status

查看当前工作流状态。

**输出内容**:
- 当前阶段
- 已完成产物列表
- 下一阶段任务

## 最佳实践

### 1. 需求分析阶段
- 提供尽可能详细的需求描述
- 明确功能边界和约束条件
- 参考记忆系统中的历史经验

### 2. 架构设计阶段
- 确保设计覆盖所有需求点
- 明确技术选型理由
- 设计评审后再继续

### 3. 代码开发阶段
- 按任务优先级顺序开发
- 及时提交代码
- 保持代码风格一致

### 4. 知识沉淀阶段
- 总结项目经验教训
- 更新代码模式和最佳实践
- 维护 AGENT.md
```

---

### 6.3 start Command

#### 基本信息

| 字段 | 值 |
|------|-----|
| **name** | start |
| **description** | Start the QM-AI workflow with a requirement description or document link |
| **argument-hint** | <requirement description or document URL> |

#### Command 文件

```markdown
---
name: start
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
```

---

## 七、异常处理

### 7.1 断点续传

- SessionEnd Hook 在会话结束时保存当前状态
- 状态保存在 `.qm-ai/state.json` 中
- 下次会话启动时自动恢复

### 7.2 阶段回滚

- `/qm-ai:rollback` 命令可回退到上一阶段
- 保留当前阶段的输出产物
- 记录回滚历史

---

## 八、插件目录结构

```
qm-ai-workflow/
├── .claude-plugin/
│   └── plugin.json
├── agents/
│   ├── phase-router.md
│   ├── requirement-manager.md
│   ├── design-manager.md
│   ├── code-executor.md
│   ├── frontend-coder.md
│   ├── backend-coder.md
│   └── experience-depositor.md
├── commands/
│   ├── start.md
│   ├── continue.md
│   ├── rollback.md
│   └── status.md
├── skills/
│   ├── workflow-guide/
│   ├── memory-system/
│   ├── feishu-doc/
│   ├── explore/
│   ├── req-create/
│   ├── req-change/
│   ├── requirement-complete/
│   ├── requirement-archive/
│   ├── design-create/
│   ├── design-change/
│   ├── workspace-setup/
│   ├── design-impl/
│   ├── code-commit/
│   ├── experience-index/
│   ├── mate-maintainer/
│   ├── index-manage/
│   ├── agents-memory-maintainer/
│   ├── service-overview/
│   ├── service-business/
│   ├── service-architecture/
│   └── service-ops/
├── hooks/
│   └── hooks.json
└── scripts/
    ├── state-manager.sh
    ├── template-generator.sh
    └── validator.sh
```

---

## 九、下一步

1. **Phase 4: 创建结构** - 创建插件目录和 manifest
2. **Phase 5: 实现组件** - 按最佳实践实现各组件
3. **Phase 6: 质量验证** - 使用 validator 验证插件
4. **Phase 7: 测试验证** - 测试插件功能

---

*文档结束*