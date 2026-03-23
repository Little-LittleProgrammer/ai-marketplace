---
name: requirement-archive
description: This skill should be used when requirements need to be archived, typically after project completion or when moving to maintenance phase.
version: 0.3.0
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

### 步骤 2: 创建归档目录

使用 Bash 工具创建归档目录：

```bash
mkdir -p "context/requirement/archive"
```

### 步骤 3: 获取下一个 RE 编号

从 `context/requirement/archive/index.json` 中获取当前最大编号，自动递增：

```bash
# 如果 index.json 不存在则创建
# 从已有编号中找出最大编号 +1
```

### 步骤 4: 移动文件到归档目录

使用 Bash 工具移动文件：

```bash
# 创建需求归档子目录
mkdir -p "context/requirement/archive/RE-xxx-需求名称"

# 移动相关文件
mv "context/requirement/RE-xxx-需求名称/spec.md" "context/requirement/archive/RE-xxx-需求名称/" 2>/dev/null || true
mv "context/requirement/RE-xxx-需求名称/design.md" "context/requirement/archive/RE-xxx-需求名称/" 2>/dev/null || true
mv "context/requirement/RE-xxx-需求名称/task.md" "context/requirement/archive/RE-xxx-需求名称/" 2>/dev/null || true
```

### 步骤 5: 创建归档清单文件

使用 Write 工具创建 `archive-manifest.json`：

```json
{
  "id": "RE-xxx",
  "name": "需求名称",
  "archived_at": "<timestamp>",
  "spec": "spec.md",
  "design": "design.md",
  "task": "task.md"
}
```

### 步骤 6: 更新归档索引

读取 `context/requirement/archive/index.json`，添加新条目：

```json
{
  "requirements": [
    {
      "id": "RE-xxx",
      "name": "需求名称",
      "spec": "spec.md",
      "design": "design.md",
      "task": "task.md",
      "archived_at": "<timestamp>",
      "status": "archived"
    }
  ]
}
```

### 步骤 7: 清理原目录

```bash
# 移动完成后，删除空的原需求目录（如果存在）
rmdir "context/requirement/RE-xxx-需求名称" 2>/dev/null || true
```

### 步骤 8: 更新主索引

更新 `context/requirement/index.json`，将对应需求状态改为 `archived`：

```json
{
  "requirements": [
    {
      "id": "RE-xxx",
      "name": "需求名称",
      "status": "archived",
      "archived_at": "<timestamp>"
    }
  ]
}
```

### 步骤 9: 通知用户

告知用户：
- 归档位置
- 归档内容清单
- 如何检索归档内容

## 归档目录结构

```
context/requirement/
├── archive/
│   ├── RE-001-用户认证系统/
│   │   ├── archive-manifest.json    # 归档元数据
│   │   ├── spec.md                  # 需求规格
│   │   ├── design.md                # 设计文档
│   │   └── task.md                  # 任务分解
│   ├── RE-002-商品管理系统/
│   │   └── ...
│   └── index.json                    # 归档索引
├── RE-003-新需求/                    # 未归档的需求（可能为空目录）
└── index.json                        # 主索引
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

主索引 `context/requirement/index.json`:
```json
{
  "requirements": [
    {
      "id": "RE-001",
      "name": "用户认证系统",
      "status": "archived",
      "archived_at": "2026-03-23T10:00:00Z"
    }
  ]
}
```

归档索引 `context/requirement/archive/index.json`:
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
5. **原子操作**: 建议在操作前备份 index.json，以便失败时回滚

## 错误处理

| 错误 | 处理方式 |
|------|----------|
| 需求不存在 | 检查 index.json，确认需求 ID 正确 |
| 文件不存在 | 跳过不存在的文件，继续归档其他文件 |
| 目录已存在 | 询问用户是否覆盖或使用新编号 |
| index.json 损坏 | 尝试从 archive/index.json 重建 |

## 相关 Skills

- **requirement-complete**: 需求完成标记
- **experience-index**: 归档内容检索
- **experience-depositor**: 经验沉淀
