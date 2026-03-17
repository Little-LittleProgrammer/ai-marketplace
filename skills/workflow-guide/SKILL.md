---
name: workflow-guide
description: This skill should be used when the user asks about "workflow", "工作流", "开发流程", "how to use qm-ai", "命令怎么用", or needs guidance on the development process.
version: 0.1.0
---

# QM-AI Workflow 指南

## 工作流概览

QM-AI Workflow 是一个覆盖从需求到开发完成的完整工作流系统，包含以下阶段：

| 阶段 | 状态 | 主要产物 | 触发命令 |
|------|------|----------|----------|
| 需求分析 | ANALYSIS | spec.md | /qm-ai:start → /qm-ai:continue |
| 架构设计 | DESIGN | design.md | /qm-ai:continue |
| 任务分解 | TASK | task.md | /qm-ai:continue |
| 代码开发 | CODING | 源代码 | /qm-ai:continue |
| 测试验证 | TESTING | 测试代码 | 自动流转 |
| 知识沉淀 | COMPLETE | AGENT.md更新 | /qm-ai:knowledge |

## 产物定义

### spec.md（需求规格文档）

**路径**: `requirement/spec-{id}.md`

**模板结构**:
```markdown
# 需求规格：{需求名称}

## 概述
[需求概述]

## 功能需求
### 功能点1
- 描述：
- 验收标准：

## 非功能需求
- 性能：
- 安全：

## 边界约束
[技术约束、业务约束]

## 用户故事
[用户故事列表]
```

### design.md（设计文档）

**路径**: `requirement/design-{id}.md`

**模板结构**:
```markdown
# 架构设计：{项目名称}

## 系统架构
[架构图、组件说明]

## API 设计
### 接口1
- 路径：
- 方法：
- 请求/响应：

## 数据模型
[ER图、表结构]

## 技术选型
[技术栈说明]
```

### task.md（任务文档）

**路径**: `requirement/task-{id}.md`

**模板结构**:
```markdown
# 任务分解：{需求名称}

## 任务列表
### 任务1
- 描述：
- 依赖：
- 优先级：
- 预估工时：

## 依赖关系
[依赖关系图]
```

## 命令指南

### /qm-ai:init

冷启动初始化，分析现有项目并生成或更新 AGENT.md。

**用法**:
```
/qm-ai:init
```

**流程**:
1. 扫描项目目录结构
2. 分析技术栈和代码模式
3. 生成或更新 AGENT.md
4. 初始化 context/ 知识库

**适用场景**:
- 新项目首次使用插件
- 项目结构发生重大变化
- 需要更新项目知识总结

### /qm-ai:start

启动工作流，接受需求描述或文档链接。

**用法**:
```
/qm-ai:start 帮我开发一个用户认证系统
/qm-ai:start https://feishu.cn/docx/xxx
```

**流程**:
1. phase-router 分析意图
2. 如果是简单描述 → 触发 explore skill 进行需求探索
3. 如果是链接 → 触发 feishu-doc skill 获取文档
4. 路由到 requirement-manager 开始需求分析

### /qm-ai:continue

确认当前阶段产物，进入下一阶段。

**使用时机**:
- 用户审核并确认当前阶段产物
- 准备进入下一阶段

**注意**: 执行前请确保当前产物已保存并通过审核。

### /qm-ai:rollback

回滚到上一阶段，保留当前产物。

**使用时机**:
- 当前阶段需要重新处理
- 用户不满意当前产物

### /qm-ai:status

查看当前工作流状态。

**输出内容**:
- 当前阶段
- 已完成产物列表
- 下一阶段任务

## 最佳实践

### 1. 需求分析阶段
- 提供尽可能详细的需求描述
- 明确功能边界和约束条件
- 参考记忆系统中的历史经验

### 2. 架构设计阶段
- 确保设计覆盖所有需求点
- 明确技术选型理由
- 设计评审后再继续

### 3. 代码开发阶段
- 按任务优先级顺序开发
- 及时提交代码
- 保持代码风格一致

### 4. 知识沉淀阶段
- 总结项目经验教训
- 更新代码模式和最佳实践
- 维护 AGENT.md