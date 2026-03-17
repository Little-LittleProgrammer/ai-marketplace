---
name: code-commit
description: This skill should be used when the user wants to commit code, prepare for code submission, or manage version control operations.
version: 0.1.0
---

# 代码提交

## 概述

此 Skill 用于处理代码提交，包括代码审查、提交信息编写、版本管理。

## 提交流程

### 1. 代码检查

- 运行测试
- 检查代码规范
- 确认无遗漏文件

### 2. 暂存文件

```bash
git add <files>
# 或
git add .
```

### 3. 编写提交信息

遵循约定式提交格式：
```
<type>(<scope>): <subject>

<body>

<footer>
```

### 4. 提交代码

```bash
git commit -m "feat(auth): add user login"
```

## 提交类型

| 类型 | 说明 |
|------|------|
| feat | 新功能 |
| fix | 修复 bug |
| docs | 文档更新 |
| style | 代码格式 |
| refactor | 重构 |
| test | 测试 |
| chore | 构建/工具 |

## 提交信息示例

```
feat(auth): add multi-factor authentication

- Add TOTP-based authentication
- Add backup codes generation
- Update user model for MFA settings

Closes #123
```

## 最佳实践

1. **原子提交**: 每次提交一个逻辑变更
2. **清晰描述**: 提交信息清晰描述变更
3. **关联需求**: 关联需求/问题编号
4. **检查测试**: 提交前运行测试