---
name: req-change
description: This skill should be used when the user wants to modify existing requirements, add new features to requirements, or change requirement specifications.
version: 0.1.0
---

# 需求变更

## 概述

此 Skill 用于处理需求变更请求，包括修改、添加、删除需求内容。

## 变更流程

### 1. 分析变更请求

- 理解变更内容
- 评估变更影响范围
- 识别受影响的功能点

### 2. 影响分析

评估变更对以下方面的影响：
- 其他需求点
- 已完成的设计
- 已开发的代码
- 测试用例

### 3. 更新文档

- 更新 `spec-{id}.md`
- 记录变更历史
- 更新 `requirement/index.json`

## 变更记录格式

在需求文档中添加变更记录：

```markdown
## 变更历史

| 版本 | 日期 | 变更内容 | 变更人 |
|------|------|----------|--------|
| 1.1 | 2026-03-16 | 新增多因素认证功能 | - |
```

## 变更类型

### 新增功能
- 添加新的功能点
- 更新验收标准

### 修改功能
- 更新功能描述
- 调整验收标准

### 删除功能
- 标记删除状态
- 记录删除原因

## 最佳实践

1. **影响评估**: 变更前评估影响范围
2. **版本管理**: 保留变更历史
3. **通知相关方**: 通知设计和开发团队
4. **更新索引**: 同步更新 index.json