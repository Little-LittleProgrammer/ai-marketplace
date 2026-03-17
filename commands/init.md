---
name: init
description: Initialize the project by analyzing existing code and generating or updating AGENT.md with project knowledge summary
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Agent
  - Skill
---

# 冷启动初始化

Analyze existing project structure and generate or update AGENT.md with comprehensive project knowledge.

## Instructions

### 1. Check Existing Knowledge

First, check if AGENT.md already exists:
- If exists: Read and analyze current content, then update with new findings
- If not exists: Create new AGENT.md from scratch

### 2. Analyze Project Structure

Scan the project directory to understand:

```
project/
├── src/              # Source code
├── tests/            # Test files
├── docs/             # Documentation
├── config/           # Configuration
├── package.json      # Dependencies (Node.js)
├── requirements.txt  # Dependencies (Python)
└── ...
```

Use Glob to find:
- `**/*.{ts,tsx,js,jsx,py,go,java}` - Source files
- `**/package.json` - Node.js projects
- `**/requirements.txt` - Python projects
- `**/*.config.{js,ts,json}` - Config files

### 3. Analyze Technology Stack

Identify technologies used:

**Frontend**:
- React/Vue/Angular detection
- Build tools (Webpack/Vite/Next.js)
- UI frameworks

**Backend**:
- Node.js/Python/Go/Java detection
- Frameworks (Express/FastAPI/Gin/Spring)
- Database (PostgreSQL/MySQL/MongoDB)

**Infrastructure**:
- Docker/Kubernetes
- CI/CD configuration
- Cloud services

### 4. Analyze Code Patterns

Use Grep to find common patterns:
- Design patterns (Repository, Factory, etc.)
- Coding conventions
- Architecture patterns

### 5. Generate AGENT.md

Create or update AGENT.md with:

```markdown
# 项目名称

## 项目概述
[自动生成的项目描述]

## 技术栈
[检测到的技术栈]

## 架构概览
[分析得出的架构]

## 代码模式
[发现的代码模式]

## 最佳实践
[从代码中提取的最佳实践]

## 常用命令
[项目相关的命令]

## 目录结构
[项目目录说明]

## 注意事项
[需要特别注意的地方]
```

### 6. Update Context Knowledge

After generating AGENT.md:
- Create `context/` directory if not exists
- Initialize `context/index.json`
- Move detailed patterns to `context/patterns/`
- Move best practices to `context/best-practices/`

## Output Format

```
## 冷启动初始化完成

### 项目信息
- **项目类型**: [Web/App/Service/Library]
- **技术栈**: [Frontend + Backend + Database]
- **代码规模**: [文件数/代码行数]

### AGENT.md 状态
- [x] 已创建/更新
- [x] 技术栈已分析
- [x] 架构已总结
- [x] 模式已提取

### 关键发现
1. [发现1]
2. [发现2]
3. [发现3]

### 建议下一步
- [建议1]
- [建议2]

### 可用命令
- /qm-ai:start - 开始工作流
- /qm-ai:status - 查看状态
```

## Example Usage

```
User: /qm-ai:init

Response:
## 冷启动初始化完成

### 项目信息
- **项目类型**: Web 全栈应用
- **技术栈**: React + Node.js + PostgreSQL
- **代码规模**: 156 文件

### AGENT.md 状态
- [x] 已创建
- [x] 技术栈已分析
- [x] 架构已总结
- [x] 模式已提取

### 关键发现
1. 使用 Repository 模式进行数据访问
2. 前端采用组件化架构
3. API 使用 RESTful 风格

### 建议下一步
- 运行 /qm-ai:start 开始新需求开发
- 查看 AGENT.md 了解项目详情
```

## Error Handling

- **Empty directory**: Report that project has no code files
- **Permission denied**: Report file access issues
- **Large project**: Limit analysis to avoid timeout