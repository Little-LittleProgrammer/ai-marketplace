---
name: state-management
description: This skill should be used when agents need to update or manage the workflow state file (.qm-ai/state.json). Provides standardized state update procedures.
version: 0.1.0
---

# 工作流状态管理

## 概述

此 Skill 定义了 `.qm-ai/state.json` 的标准更新规则和职责分工，确保状态一致性。

## 状态文件结构

```json
{
  "current_phase": "ANALYSIS|DESIGN|TASK|CODING|TESTING|COMPLETE",
  "started_at": "2026-03-23T10:00:00Z",
  "updated_at": "2026-03-23T10:30:00Z",
  "requirement_id": "RE-001",
  "requirement_path": "context/requirement/RE-xxx-需求名称",
  "outputs": {
    "analysis": ["spec-001.md"],
    "design": ["design-001.md"],
    "task": ["task-001.md"],
    "coding": ["src/..."],
    "testing": ["tests/..."]
  },
  "rollback_history": []
}
```

## 更新职责分工

### 各 Agent 状态更新职责

| Agent | 更新时机 | 更新内容 |
|-------|----------|----------|
| **requirement-manager** | 需求创建/变更完成 | `current_phase: ANALYSIS`, `outputs.analysis` |
| **design-manager** | 设计创建/变更完成 | `current_phase: DESIGN`, `outputs.design` |
| **task-decomposer** | 任务分解完成 | `current_phase: TASK`, `outputs.task` |
| **code-executor** | 开发完成 | `current_phase: CODING`, `outputs.coding` |
| **test-generator** | 测试完成 | `current_phase: TESTING`, `outputs.testing` |
| **experience-depositor** | 知识沉淀完成 | `current_phase: COMPLETE` |

### 更新规则

1. **Only update on completion**: Agent 只在完成阶段产物后更新状态
2. **Update timestamp**: 必须同时更新 `updated_at` 字段
3. **Append outputs**: 追加到 `outputs` 对象，不删除已有内容
4. **Phase validation**: 确保新阶段在允许的状态机中

## 标准更新流程

### 1. Read Current State

```python
import json

with open('.qm-ai/state.json', 'r', encoding='utf-8') as f:
    state = json.load(f)
```

### 2. Validate Transition

```python
valid_transitions = {
    'IDLE': ['ANALYSIS'],
    'ANALYSIS': ['DESIGN'],
    'DESIGN': ['TASK'],
    'TASK': ['CODING'],
    'CODING': ['TESTING'],
    'TESTING': ['COMPLETE'],
    'COMPLETE': ['IDLE']  # For new requirement
}

if new_phase not in valid_transitions.get(state['current_phase'], []):
    raise ValueError(f"Invalid transition from {state['current_phase']} to {new_phase}")
```

### 3. Update State

```python
from datetime import datetime, timezone

state['current_phase'] = new_phase
state['updated_at'] = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
state['outputs'][phase_key] = output_files
```

### 4. Write State

```python
with open('.qm-ai/state.json', 'w', encoding='utf-8') as f:
    json.dump(state, f, indent=2, ensure_ascii=False)
    f.write('\n')
```

## 特殊情况处理

### Rollback (回滚)

当执行 `/qm-ai:rollback` 命令时：
- 由 `rollback` command handler 更新状态
- 添加 rollback 记录到 `rollback_history`
- 不删除产物，只回退阶段

### Session End Hook

`session-end-persist.sh` 只更新 `updated_at` 字段，不改变阶段或其他数据。

### Concurrent Access

如果担心并发问题，可以：
1. 读取时记录版本号
2. 写入时检查版本号是否变化
3. 如果变化，重新读取并合并

## 最佳实践

1. **Always update timestamp**: 任何更新都必须刷新 `updated_at`
2. **Preserve history**: 不要清空 `outputs`，只追加
3. **Validate before write**: 写入前验证 JSON 格式
4. **Error handling**: 更新失败时报告错误，不静默忽略
