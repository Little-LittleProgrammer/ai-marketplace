---
name: requirement-archive
description: This skill should be used when requirements need to be archived, typically after project completion or when moving to maintenance phase.
version: 0.1.0
---

# 归档管理

## 概述

此 Skill 用于归档已完成的需求数据，整理项目资产。

## 归档流程

### 1. 准备归档

- 确认需求已完成
- 收集所有相关文档
- 整理项目资产

### 2. 创建归档目录

```
requirement/archive/{project-id}/
├── spec.md
├── design.md
├── task.md
└── summary.md
```

### 3. 移动文件

将需求文档移动到归档目录

### 4. 更新索引

更新 `requirement/index.json` 和 `requirement/archive/index.json`

## 归档内容

### 必须归档
- 需求规格文档
- 设计文档
- 任务分解文档

### 建议归档
- 项目总结
- 经验教训
- 技术决策记录

## 归档清单

```markdown
# 归档清单

## 项目信息
- **项目ID**: proj-001
- **项目名称**: 用户认证系统
- **归档时间**: 2026-03-16

## 归档文件
- [x] spec.md
- [x] design.md
- [x] task.md

## 相关资源
- 代码仓库: [链接]
- 文档链接: [链接]
```

## 最佳实践

1. **完整归档**: 确保所有相关文档归档
2. **版本标记**: 记录归档版本信息
3. **可检索**: 保持归档内容可检索
4. **定期清理**: 清理过期的归档数据