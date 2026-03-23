---
name: requirement-archive
description: This skill should be used when requirements need to be archived, typically after project completion or when moving to maintenance phase.
version: 0.2.0
---

# 需求归档

## 概述

此 Skill 用于归档已完成的需求，将相关文件整理到 `context/requirement/archive/RE-xxx-需求名称/` 目录，并更新归档索引。

## 使用场景

- 需求已完成开发，进入维护阶段
- 项目结束，需要归档所有需求文档
- 用户明确请求归档需求

## 归档前置条件

归档前请确认：
- [ ] 需求已标记为 `completed` 状态（通过 requirement-complete skill）
- [ ] 所有相关文件已保存
- [ ] 经验教训已沉淀（如有）

## 归档流程

### 步骤 1: 收集需求信息

从 `.qm-ai/state.json` 和 `context/requirement/index.json` 获取：
- 需求 ID（如 RE-001）
- 需求名称
- 相关文件路径（spec, design, task）

### 步骤 2: 执行归档脚本

使用 Bash 工具调用归档脚本：

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/archive-requirement.sh" "<requirement-id>" "<requirement-name>"
```

示例：
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/archive-requirement.sh" "RE-001" "用户认证系统"
```

或使用自动编号：
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/archive-requirement.sh" "AUTO" "用户认证系统"
```

### 步骤 3: 验证归档结果

检查归档结果：
- 归档目录已创建：`context/requirement/archive/RE-xxx-需求名称/`
- 文件已移动到归档目录
- `context/requirement/archive/index.json` 已更新
- 原始目录中的文件已移除

### 步骤 4: 通知用户

告知用户：
- 归档位置
- 归档内容清单
- 如何检索归档内容

## 归档目录结构

```
context/requirement/archive/
├── RE-001-用户认证系统/
│   ├── archive-manifest.json    # 归档元数据
│   ├── spec.md                  # 需求规格
│   ├── design.md                # 设计文档
│   └── task.md                  # 任务分解
├── RE-002-商品管理系统/
│   └── ...
└── index.json                    # 归档索引
```

## archive-manifest.json 格式

```json
{
  "id": "RE-001",
  "name": "用户认证系统",
  "archived_at": "2026-03-23T10:00:00Z",
  "spec": "spec.md",
  "design": "design.md",
  "task": "task.md"
}
```

## index.json 格式

```json
{
  "requirements": [
    {
      "id": "RE-001",
      "name": "用户认证系统",
      "spec": "spec.md",
      "design": "design.md",
      "task": "task.md",
      "archived_at": "2026-03-23T10:00:00Z",
      "status": "archived"
    }
  ]
}
```

## phase-router 路由示例

```example
Context: User wants to archive completed requirement artifacts
user: "这个需求已经结束，帮我归档到历史记录"
assistant: "检测到需求归档意图，准备进入需求归档流程。"
<commentary>
phase-router routes to requirement-manager, which then invokes requirement-archive.
</commentary>
```

## 最佳实践

1. **先完成再归档**: 确保需求通过 requirement-complete 标记为完成
2. **保持可检索**: 归档后仍可通过 experience-index skill 检索
3. **完整移动**: 确保所有相关文件都移动到归档目录
4. **更新索引**: 始终保持 index.json 与实际归档状态一致

## 错误处理

| 错误 | 处理方式 |
|------|----------|
| 需求不存在 | 检查 index.json，确认需求 ID 正确 |
| 文件不存在 | 跳过不存在的文件，继续归档其他文件 |
| 目录已存在 | 询问用户是否覆盖或使用新编号 |

## 相关 Skills

- **requirement-complete**: 需求完成标记
- **experience-index**: 归档内容检索
- **experience-depositor**: 经验沉淀
