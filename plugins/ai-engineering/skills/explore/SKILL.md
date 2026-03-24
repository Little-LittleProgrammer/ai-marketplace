---
name: explore
description: This skill should be used when the user provides a brief requirement description that needs exploration and expansion. It enables brainstorming and requirement clarification without writing code.
version: 0.1.0
---

# 探索/分析模式

## 概述

此 Skill 用于探索和分析需求，进行头脑风暴，不涉及代码编写。当用户提供简单描述时，帮助扩展和澄清需求。

## 触发条件

- 用户在 `/qm-ai:start` 中只提供了简单描述
- 用户需要进行需求探索和澄清
- 用户想进行头脑风暴但不需要立即编码

## 工作流程

### 1. 分析用户输入

- 识别核心需求点
- 分析技术领域（前端/后端/全栈）
- 评估复杂度

### 2. 探索需求细节

通过提问扩展需求：

- **功能维度**: 需要哪些具体功能？
- **用户维度**: 目标用户是谁？
- **场景维度**: 使用场景有哪些？
- **约束维度**: 有哪些技术或业务约束？

### 3. 参考记忆系统

- 读取 `AGENTS.md` 了解项目背景
- 检索 `context/` 中的相关模式
- 参考历史决策

### 4. 生成需求概要

输出扩展后的需求概要，供用户确认。

## 服务分析 Skills

在探索现有代码库时，可调用以下 skills：

- **service-overview**: 服务概览分析
- **service-business**: 业务逻辑分析
- **service-architecture**: 架构分析
- **service-ops**: 服务协议分析

## 输出格式

```markdown
## 需求探索报告

### 原始描述
[用户提供的原始描述]

### 扩展需求
1. [需求点1]
2. [需求点2]
3. [需求点3]

### 待确认问题
1. [问题1]
2. [问题2]

### 建议技术方案
[技术方向建议]

### 下一步
[建议的下一步操作]
```

## 最佳实践

1. **充分提问**: 不要假设，通过提问澄清模糊点
2. **参考历史**: 利用记忆系统中的经验
3. **结构化输出**: 提供清晰的探索报告
4. **用户确认**: 确保用户理解并同意扩展后的需求