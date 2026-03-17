---
name: design-create
description: This skill should be used when the user needs to create a design document, architecture proposal, or technical specification.
version: 0.1.0
---

# 创建方案

## 概述

此 Skill 用于创建架构设计文档，包括系统架构、API设计、数据模型和技术选型。

## 设计流程

### 1. 分析需求

- 读取需求规格文档
- 识别核心功能模块
- 确定技术要求

### 2. 架构设计

- 设计系统架构
- 划分服务/模块边界
- 定义组件职责

### 3. 详细设计

- API 接口设计
- 数据模型设计
- 接口契约定义

### 4. 技术选型

- 选择技术栈
- 评估技术方案
- 记录决策理由

## 输出模板

```markdown
# 架构设计：{项目名称}

## 1. 系统架构

### 1.1 架构概览
[架构图]

### 1.2 组件说明
| 组件 | 职责 | 技术栈 |
|------|------|--------|
| | | |

### 1.3 部署架构
[部署图]

## 2. API 设计

### 2.1 接口列表

#### {接口名称}
- **路径**: `POST /api/v1/resource`
- **描述**: [接口描述]
- **请求**:
```json
{
  "field": "type"
}
```
- **响应**:
```json
{
  "code": 0,
  "data": {}
}
```

## 3. 数据模型

### 3.1 ER 图
[ER图]

### 3.2 表结构
```sql
CREATE TABLE example (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 4. 技术选型

| 类别 | 选择 | 理由 |
|------|------|------|
| 前端 | | |
| 后端 | | |
| 数据库 | | |

## 5. 安全设计

[安全措施]

## 6. 性能设计

[性能优化策略]
```

## 最佳实践

1. **需求覆盖**: 设计需覆盖所有需求点
2. **可扩展性**: 预留扩展空间
3. **文档清晰**: 图文结合，易于理解
4. **决策记录**: 记录重要的技术决策