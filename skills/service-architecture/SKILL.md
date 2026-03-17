---
name: service-architecture
description: This skill should be used when the user wants to analyze service architecture, understand design patterns, or evaluate technical decisions.
version: 0.1.0
---

# 架构分析

## 概述

此 Skill 用于分析服务的架构设计，评估技术决策，理解系统结构。

## 分析内容

### 1. 架构风格
- 分层架构
- 微服务架构
- 事件驱动架构
- CQRS

### 2. 设计模式
- 使用的设计模式
- 模式应用场景
- 模式优缺点

### 3. 技术决策
- 技术选型理由
- 架构权衡
- 技术债务

## 分析流程

### 1. 宏观架构
- 识别架构风格
- 分析架构层次
- 理解架构约束

### 2. 微观设计
- 识别设计模式
- 分析模块设计
- 评估代码质量

### 3. 技术评估
- 评估技术选择
- 识别技术风险
- 发现改进空间

## 输出格式

```markdown
## 架构分析

### 架构风格

**类型**: {架构类型}

**层次结构**:
```
┌─────────────────┐
│   Presentation  │
├─────────────────┤
│   Application   │
├─────────────────┤
│     Domain      │
├─────────────────┤
│ Infrastructure  │
└─────────────────┘
```

### 设计模式

| 模式 | 位置 | 用途 |
|------|------|------|
| Repository | data/ | 数据访问抽象 |
| Factory | services/ | 对象创建 |
| Strategy | handlers/ | 算法选择 |

### 技术评估

#### 优点
- {优点1}
- {优点2}

#### 待改进
- {改进点1}
- {改进点2}

### 架构建议

1. {建议1}
2. {建议2}
```

## 最佳实践

1. **多视角**: 从多个视角分析架构
2. **历史追溯**: 了解架构演进历史
3. **权衡分析**: 分析架构权衡
4. **文档更新**: 更新架构文档