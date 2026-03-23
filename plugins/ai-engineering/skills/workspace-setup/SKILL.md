---
name: workspace-setup
description: This skill should be used when the user needs to set up development environment, initialize project structure, or configure development tools.
version: 0.1.0
---

# 环境搭建

## 概述

此 Skill 用于搭建开发环境，初始化项目结构，配置开发工具。

## 搭建流程

### 1. 环境准备

- 检查系统环境
- 安装必要工具
- 配置环境变量

### 2. 项目初始化

- 创建项目目录结构
- 初始化包管理器
- 配置构建工具

### 3. 代码配置

- 配置代码规范
- 设置 Git 仓库
- 配置 CI/CD

### 4. 开发工具

- 配置 IDE 设置
- 设置调试环境
- 配置测试框架

## 目录结构模板

```
{project-name}/
├── src/
│   ├── modules/
│   ├── shared/
│   └── index.ts
├── tests/
│   ├── unit/
│   └── integration/
├── docs/
├── scripts/
├── .gitignore
├── package.json
└── README.md
```

## 常用配置

### package.json (Node.js)
```json
{
  "name": "project-name",
  "version": "1.0.0",
  "scripts": {
    "dev": "...",
    "build": "...",
    "test": "..."
  }
}
```

### .gitignore
```
node_modules/
dist/
.env
*.log
```

## 技术栈配置

### 前端项目
- React/Vue/Angular
- TypeScript
- ESLint + Prettier
- Vite/Webpack

### 后端项目
- Node.js/Python/Go
- 数据库连接
- API 框架
- 测试框架

## 最佳实践

1. **标准化**: 使用标准的项目结构
2. **自动化**: 配置自动化脚本
3. **文档化**: 编写环境配置文档
4. **版本控制**: 使用 Git 管理代码