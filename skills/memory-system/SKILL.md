---
name: memory-system
description: This skill should be used when the user asks about "记忆系统", "AGENT.md", "知识库", "memory", "knowledge base", or needs to understand how to use or update the project's knowledge storage.
version: 0.1.0
---

# 记忆系统使用指南

## 概述

QM-AI Workflow 的记忆系统用于存储和检索项目知识，包括：
- **全局知识**: `AGENT.md` - 项目入口文件
- **局部知识**: `context/` - 分类知识库

## 存储结构

```
项目根目录/
├── AGENT.md                    # 项目入口，全局知识
├── context/                    # 知识库
│   ├── index.json             # 知识库索引
│   ├── index.md               # 知识库索引（可读）
│   ├── patterns/              # 代码模式
│   ├── best-practices/        # 最佳实践
│   ├── templates/             # 模板
│   ├── decisions/             # 设计决策记录(ADR)
│   └── problems/              # 问题解决方案
```

## AGENT.md 格式

```markdown
# 项目名称

## 项目概述
[项目简介]

## 技术栈
[使用的技术栈]

## 代码模式
[常用的代码模式和约定]

## 最佳实践
[项目特定的最佳实践]

## 历史决策
[重要的技术决策记录]

## 常见问题
[常见问题及解决方案]
```

## 知识分类

### patterns/ - 代码模式
可复用的代码模式、组件结构。

**格式**: `{pattern-name}.md`

### best-practices/ - 最佳实践
项目开发过程中的最佳实践总结。

**格式**: `{topic}.md`

### templates/ - 模板
常用的代码模板、配置模板。

**格式**: `{template-name}.md`

### decisions/ - 设计决策
Architecture Decision Records (ADR)。

**格式**: `ADR-{id}.md`

### problems/ - 问题解决方案
遇到的问题及其解决方案。

**格式**: `{problem-id}.md`

## 使用方式

### 读取知识

1. **读取全局知识**:
   - 读取 `AGENT.md` 获取项目概述

2. **搜索局部知识**:
   - 读取 `context/index.json` 获取索引
   - 根据索引定位具体文档

### 更新知识

1. **更新 AGENT.md**:
   - 使用 agents-memory-maintainer skill

2. **添加新知识**:
   - 创建对应的文档文件
   - 使用 index-manage skill 更新索引

## 索引维护

`context/index.json` 示例：
```json
{
  "version": "1.0.0",
  "updated_at": "2026-03-16T10:00:00Z",
  "categories": {
    "patterns": { "count": 5, "path": "patterns/" },
    "best-practices": { "count": 3, "path": "best-practices/" },
    "templates": { "count": 4, "path": "templates/" },
    "decisions": { "count": 2, "path": "decisions/" },
    "problems": { "count": 6, "path": "problems/" }
  }
}
```

## 最佳实践

1. **及时更新**: 项目结束后及时沉淀经验
2. **分类清晰**: 将知识放入正确的分类
3. **索引同步**: 添加知识后更新索引
4. **定期清理**: 删除过时或不再使用的知识