---
name: requirement-complete
description: This skill should be used when a requirement has been fully implemented and needs to transition to completion status.
version: 0.1.0
---

# 完成流转

## 概述

此 Skill 用于标记需求完成，流转需求状态，准备归档。

## 完成检查

### 1. 验证完成条件

- [ ] 所有功能点已实现
- [ ] 验收标准已满足
- [ ] 测试用例已通过
- [ ] 文档已更新

### 2. 收集完成信息

- 实际完成时间
- 遗留问题（如有）
- 经验总结

### 3. 更新状态

更新 `requirement/index.json`:
```json
{
  "id": "req-001",
  "status": "completed",
  "completed_at": "2026-03-16T10:00:00Z"
}
```

## 输出格式

生成完成报告：

```markdown
# 需求完成报告

## 基本信息
- **需求ID**: req-001
- **需求名称**: 用户认证系统
- **完成时间**: 2026-03-16

## 完成清单
- [x] 功能实现
- [x] 测试通过
- [x] 文档更新

## 遗留问题
[无 / 问题描述]

## 后续事项
[需要跟进的事项]

## 经验总结
[项目经验，供知识沉淀使用]
```

## 状态流转

```
pending → in_progress → completed → archived
```

## 最佳实践

1. **完整验证**: 确保所有验收标准满足
2. **文档同步**: 更新相关文档
3. **经验提取**: 提取可复用的经验
4. **通知团队**: 通知相关方需求完成