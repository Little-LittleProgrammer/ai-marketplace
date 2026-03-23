---
name: service-business
description: This skill should be used when the user wants to understand business logic, analyze business rules, or trace business workflows in existing code.
version: 0.1.0
---

# 业务逻辑分析

## 概述

此 Skill 用于分析服务的业务逻辑，理解业务规则和工作流程。

## 分析内容

### 1. 业务领域
- 核心业务概念
- 业务实体
- 业务关系

### 2. 业务规则
- 验证规则
- 计算规则
- 状态转换规则

### 3. 业务流程
- 主流程
- 异常流程
- 边界情况

## 分析流程

### 1. 识别业务实体
- 从数据模型识别
- 从 API 参数识别
- 从代码注释识别

### 2. 追踪业务流程
- 从入口追踪
- 分析条件分支
- 记录状态变化

### 3. 提取业务规则
- 从验证逻辑提取
- 从计算逻辑提取
- 从状态机提取

## 输出格式

```markdown
## 业务逻辑分析

### 业务领域

#### 核心实体
| 实体 | 属性 | 说明 |
|------|------|------|
| User | id, name, email | 用户实体 |
| Order | id, items, status | 订单实体 |

### 业务规则

#### 规则1: {规则名称}
- **触发条件**: {condition}
- **规则描述**: {description}
- **代码位置**: {file:line}

### 业务流程

#### 流程1: {流程名称}
```
开始 → 步骤1 → 判断? → 是 → 步骤2 → 结束
                  ↓
                  否 → 步骤3 → 结束
```

### 状态机

#### {实体} 状态
```
pending → processing → completed
                 ↓
               failed
```
```

## 最佳实践

1. **文档化**: 将隐性知识显性化
2. **流程图**: 使用流程图描述复杂流程
3. **状态图**: 使用状态图描述状态转换
4. **代码映射**: 建立业务与代码的映射关系