# QM-AI Workflow

一个覆盖从需求到开发开发完整生命周期的 multi-agent 工作流插件，支持智能意图识别、分步确认、记忆系统和断点续传。

## 特性

- **智能意图路由**: phase-router 分析用户意图并分发到对应的专业 Agent
- **Multi-Agent 协作**: 9 个专业 Agent 协同工作（路由、需求、设计、任务、开发、测试、沉淀）
- **分步确认流程**: 每个阶段输出产物需用户审核确认后进入下一阶段
- **记忆系统**: AGENT.md + context/知识库，支持持续学习和经验沉淀
- **断点续传**: SessionEnd Hook 刷新 `.qm-ai/state.json` 的 `updated_at` 并提示未落盘产物，支持中断后恢复
- **阶段回滚**: 支持回退到上一阶段重新处理，保留当前产物

## 安装

### 方式一：从 GitHub 安装（推荐）

```bash
# 使用 Claude Code 命令安装
claude plugins install https://github.com/Little-LittleProgrammer/ai-marketplace

# 或使用简写命令
cc plugins install https://github.com/Little-LittleProgrammer/ai-marketplace
```

### 方式二：手动复制安装

```bash
# 复制到 Claude 插件目录
cp -r qm-ai-workflow ~/.claude/plugins/

# 或使用 --plugin-dir 指定路径
cc --plugin-dir /path/to/qm-ai-workflow
```

## 快速开始

```bash
# 1. 冷启动初始化（分析现有项目，生成 AGENT.md）
/qm-ai:init

# 2. 启动工作流（提供需求描述或飞书文档链接）
/qm-ai:start 帮我开发一个用户认证系统
/qm-ai:start https://feishu.cn/docx/xxx

# 3. 确认当前阶段产物，进入下一阶段
/qm-ai:continue

# 4. 查看当前工作流状态
/qm-ai:status

# 5. 回滚到上一阶段（保留当前产物）
/qm-ai:rollback

# 6. 流程优化与知识沉淀（项目完成后使用；与下面等价）
/qm-ai:optimize-flow
/qm-ai:knowledge
```

## 工作流阶段

| 阶段 | 状态 | 产物 | 负责 Agent | 触发命令 |
|------|------|------|------------|----------|
| **需求分析** | ANALYSIS | spec.md | requirement-manager | /qm-ai:start |
| **架构设计** | DESIGN | design.md | design-manager | /qm-ai:continue |
| **任务分解** | TASK | task.md | task-decomposer | /qm-ai:continue |
| **代码开发** | CODING | 源代码 | code-executor | /qm-ai:continue |
| **测试验证** | TESTING | 测试代码 | test-generator | 自动流转 |
| **知识沉淀** | COMPLETE | AGENT.md 更新 | experience-depositor | /qm-ai:knowledge 或 /qm-ai:optimize-flow |

## 数据存储结构

```
project/
├── AGENT.md                    # 项目全局知识
├── .qm-ai/
│   └── state.json             # 工作流状态文件（/qm-ai:start 创建）
├── requirement/               # 需求文档存储
│   ├── index.json            # 需求索引
│   ├── spec-{id}.md          # 需求规格文档
│   ├── design-{id}.md        # 设计文档
│   ├── task-{id}.md          # 任务文档
│   └── archive/              # 归档目录
├── context/                   # 知识库（/qm-ai:init 创建）
│   ├── index.json            # 知识库索引
│   ├── patterns/             # 代码模式
│   ├── best-practices/       # 最佳实践
│   ├── templates/            # 模板
│   ├── decisions/            # 设计决策记录 (ADR)
│   └── problems/             # 问题解决方案
└── workspace/                 # 服务代码
    └── {service-name}/
```

## 组件清单

### Agents (9 个)

| Agent | 职责 | 颜色 | 工具权限 |
|-------|------|------|----------|
| **phase-router** | 意图识别和路由中枢 | cyan | Read, AskUserQuestion, Skill |
| **requirement-manager** | 需求生命周期管理 | blue | Read, Write, Edit |
| **design-manager** | 设计/架构生命周期管理 | green | Read, Write, Edit |
| **task-decomposer** | 任务分解和规划 | yellow | Read, Write, Edit |
| **code-executor** | 开发生命周期协调 | yellow | Read, Write, Edit, Bash |
| **frontend-coder** | 前端开发专家 | magenta | Read, Write, Edit, Bash |
| **backend-coder** | 后端开发专家 | red | Read, Write, Edit, Bash |
| **test-generator** | 测试生成和质量保证 | green | Read, Write, Edit, Bash |
| **experience-depositor** | 经验沉淀和知识管理 | blue | Read, Write, Edit |

### Skills (22 个)

#### 需求管理 (4 个)
- `req-create` - 创建需求规格文档
- `req-change` - 处理需求变更
- `requirement-complete` - 完成需求流转
- `requirement-archive` - 归档已完成需求

#### 方案设计 (2 个)
- `design-create` - 创建架构设计方案
- `design-change` - 处理设计变更

#### 开发实施 (3 个)
- `workspace-setup` - 搭建开发环境
- `design-impl` - 实现设计代码
- `code-commit` - 处理代码提交

#### 记忆系统 (5 个)
- `memory-system` - 记忆系统使用指南
- `experience-index` - 经验检索
- `mate-maintainer` - 元数据维护
- `index-manage` - 知识索引管理
- `agents-memory-maintainer` - AGENT.md 维护

#### 服务分析 (4 个)
- `service-overview` - 服务概览分析
- `service-business` - 业务逻辑分析
- `service-architecture` - 架构分析
- `service-ops` - 服务协议分析

#### 基础 Skills (4 个)
- `workflow-guide` - 工作流使用指南
- `explore` - 需求探索/头脑风暴
- `feishu-doc` - 飞书文档下载解析
- `testing` - 测试生成支持

### Commands (6 个)

| 命令 | 功能 | 参数 |
|------|------|------|
| `/qm-ai:init` | 冷启动初始化：分析现有项目，生成/更新 AGENT.md | 无 |
| `/qm-ai:start` | 启动工作流：接受需求描述或飞书文档链接 | `<requirement or URL>` |
| `/qm-ai:continue` | 确认当前阶段产物，进入下一阶段 | 无 |
| `/qm-ai:rollback` | 回滚到上一阶段，保留当前产物 | 无 |
| `/qm-ai:status` | 查看当前工作流状态和进度 | 无 |
| `/qm-ai:optimize-flow` | 流程优化：分析工作流历史，沉淀知识 | 无 |

## 架构图

```
┌─────────────────────────────────────────────────────────────┐
│                     Commands 层                              │
│  /qm-ai:init, start, continue, rollback, status, optimize   │
├─────────────────────────────────────────────────────────────┤
│                     Agent 层（管理者）                        │
│  phase-router → requirement-manager → design-manager → ...  │
├─────────────────────────────────────────────────────────────┤
│                     Skill 层（执行者）                        │
│  需求管理 │ 方案设计 │ 开发实施 │ 记忆系统 │ 服务分析 │
└─────────────────────────────────────────────────────────────┘
                           │ 读写
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                     数据存储层                               │
│  AGENT.md │ requirement/ │ context/ │ workspace/ │ .qm-ai/ │
└─────────────────────────────────────────────────────────────┘
```

## 工作流程示意

```
用户 → phase-router (意图识别)
         │
         ├─→ requirement-manager → spec.md
         │        └─→ req-create, req-change
         │
         ├─→ design-manager → design.md
         │        └─→ design-create, design-change
         │
         ├─→ task-decomposer → task.md
         │
         ├─→ code-executor → 源代码
         │        ├─→ frontend-coder
         │        └─→ backend-coder
         │
         ├─→ test-generator → 测试代码
         │
         └─→ experience-depositor → AGENT.md 更新
                  └─→ experience-index, index-manage, ...
```

## 最佳实践

### 1. 冷启动
- 新项目或现有项目首次使用时，先执行 `/qm-ai:init`
- 生成 AGENT.md 和 context/知识库结构

### 2. 需求分析
- 提供尽可能详细的需求描述
- 或使用飞书文档链接直接导入需求
- 明确功能边界和约束条件

### 3. 阶段确认
- 每个阶段产物需仔细审核后再执行 `/qm-ai:continue`
- 如不满意当前产物，使用 `/qm-ai:rollback` 重新处理

### 4. 知识沉淀
- 项目完成后执行 `/qm-ai:optimize-flow`
- 提取可复用模式和最佳实践
- 更新 AGENT.md 和知识库

## 故障恢复

### 会话中断恢复
- SessionEnd Hook 自动保存进度到 `.qm-ai/state.json`
- 重新启动 Claude Code 后，执行 `/qm-ai:status` 查看状态
- 执行 `/qm-ai:continue` 继续工作流

### 手动恢复
```bash
# 查看当前状态
/qm-ai:status

# 如果需要重新开始
/qm-ai:start <新需求>
```

## 技术栈

- **Agents**: Markdown 定义的 Agent 配置文件
- **Skills**: Markdown 定义的 Skill 规范文档
- **Commands**: Claude Code slash commands
- **Hooks**: SessionEnd 钩子实现断点续传

## License

MIT
