---
name: testing
description: This skill should be used when the user wants to generate tests, check test coverage, or verify code quality. Provides guidance on test creation strategies and quality assurance.
version: 0.1.0
---

# 测试生成

## 概述

此 Skill 用于生成测试代码，分析测试覆盖率，确保代码质量。

## 测试类型

### 1. 单元测试 (Unit Tests)

测试独立的函数、方法或组件。

**原则**:
- 测试单一职责
- Mock 外部依赖
- 覆盖正常、边界、异常情况

**模板**:
```typescript
describe('FunctionName', () => {
  it('should return expected result for normal input', () => {
    const result = functionName('input');
    expect(result).toBe('expected');
  });

  it('should handle empty input', () => {
    expect(() => functionName('')).toThrow();
  });

  it('should handle null/undefined', () => {
    expect(() => functionName(null)).toThrow();
  });
});
```

### 2. 集成测试 (Integration Tests)

测试模块间的交互和集成。

**原则**:
- 测试真实交互
- 使用测试数据库
- 覆盖关键路径

**模板**:
```typescript
describe('API Integration', () => {
  beforeAll(async () => {
    // Setup test database
  });

  afterAll(async () => {
    // Cleanup
  });

  it('should create and retrieve user', async () => {
    const created = await createUser({ name: 'Test' });
    const retrieved = await getUser(created.id);
    expect(retrieved.name).toBe('Test');
  });
});
```

### 3. E2E 测试 (End-to-End Tests)

测试完整的用户流程。

**原则**:
- 模拟真实用户操作
- 测试关键业务流程
- 使用测试环境

## 测试框架选择

| 语言/框架 | 推荐测试框架 |
|-----------|-------------|
| JavaScript/TypeScript | Jest, Vitest |
| React | React Testing Library |
| Vue | Vue Test Utils |
| Python | pytest |
| Go | go test |
| Java | JUnit |

## 覆盖率目标

| 类型 | 最低目标 | 理想目标 |
|------|---------|---------|
| 核心业务逻辑 | 80% | 90%+ |
| API 端点 | 70% | 85%+ |
| UI 组件 | 60% | 75%+ |
| 工具函数 | 90% | 95%+ |

## 测试文件组织

```
project/
├── src/
│   ├── modules/
│   │   └── user/
│   │       ├── user.service.ts
│   │       └── user.service.test.ts  # 单元测试与源码同目录
├── tests/
│   ├── integration/                    # 集成测试
│   │   └── api.test.ts
│   └── e2e/                            # E2E 测试
│       └── user-flow.test.ts
```

## 最佳实践

### 1. 测试命名
```typescript
// 好的命名
it('should return 404 when user not found', () => {});
it('should create user with valid data', () => {});

// 不好的命名
it('test1', () => {});
it('works', () => {});
```

### 2. AAA 模式
```typescript
it('should calculate total correctly', () => {
  // Arrange
  const items = [{ price: 10 }, { price: 20 }];

  // Act
  const total = calculateTotal(items);

  // Assert
  expect(total).toBe(30);
});
```

### 3. 测试隔离
```typescript
describe('UserService', () => {
  beforeEach(() => {
    // 重置状态
    jest.clearAllMocks();
  });

  afterEach(() => {
    // 清理资源
  });
});
```

## 质量检查清单

- [ ] 所有公开方法有对应测试
- [ ] 边界情况已覆盖
- [ ] 错误处理已测试
- [ ] 测试命名清晰
- [ ] 测试相互独立
- [ ] 覆盖率达标