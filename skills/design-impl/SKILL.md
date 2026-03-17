---
name: design-impl
description: This skill should be used when the user needs to implement code based on design documents, convert designs to working code.
version: 0.1.0
---

# 编写代码

## 概述

此 Skill 用于根据设计文档实现代码，将设计转化为可运行的程序。

## 实现流程

### 1. 理解设计

- 阅读设计文档
- 理解架构和接口
- 确认技术方案

### 2. 编码实现

- 按模块/功能实现
- 遵循代码规范
- 编写单元测试

### 3. 代码审查

- 自我审查
- 处理审查反馈
- 优化代码质量

### 4. 文档更新

- 更新代码注释
- 更新 API 文档
- 更新 README

## 编码规范

### 代码风格
- 使用一致的命名规范
- 保持代码简洁
- 添加必要的注释

### 目录组织
```
src/
├── modules/
│   └── {module}/
│       ├── controller.ts
│       ├── service.ts
│       ├── model.ts
│       └── test.ts
├── shared/
│   ├── utils/
│   └── types/
└── index.ts
```

### 函数结构
```typescript
/**
 * 函数描述
 * @param param1 - 参数描述
 * @returns 返回值描述
 */
function functionName(param1: Type): ReturnType {
  // 实现
}
```

## 最佳实践

1. **模块化**: 代码按功能模块组织
2. **可测试**: 编写可测试的代码
3. **可维护**: 保持代码清晰易读
4. **性能**: 考虑性能优化
5. **安全**: 注意安全问题