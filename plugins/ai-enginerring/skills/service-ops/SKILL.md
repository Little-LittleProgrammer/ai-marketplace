---
name: service-ops
description: This skill should be used when the user wants to analyze service interfaces, understand API contracts, or document service protocols.
version: 0.1.0
---

# 服务协议分析

## 概述

此 Skill 用于分析服务的接口协议，理解 API 契约，文档化服务通信方式。

## 分析内容

### 1. API 接口
- REST API
- GraphQL
- RPC 接口

### 2. 数据契约
- 请求格式
- 响应格式
- 数据类型

### 3. 通信协议
- HTTP/HTTPS
- WebSocket
- gRPC

## 分析流程

### 1. 接口发现
- 从路由定义发现
- 从控制器发现
- 从文档发现

### 2. 契约分析
- 分析请求参数
- 分析响应结构
- 分析错误处理

### 3. 依赖分析
- 上游服务依赖
- 下游服务调用
- 外部 API 调用

## 输出格式

```markdown
## 服务协议分析

### API 端点

#### {模块} API

| 方法 | 路径 | 描述 |
|------|------|------|
| GET | /api/v1/users | 获取用户列表 |
| POST | /api/v1/users | 创建用户 |
| GET | /api/v1/users/:id | 获取用户详情 |

### 接口详情

#### GET /api/v1/users

**描述**: 获取用户列表

**查询参数**:
| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| page | number | 否 | 页码 |
| size | number | 否 | 每页数量 |

**响应**:
```json
{
  "code": 0,
  "data": {
    "items": [],
    "total": 100
  }
}
```

### 数据模型

#### User
```typescript
interface User {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
}
```

### 依赖服务

| 服务 | 协议 | 用途 |
|------|------|------|
| Auth Service | HTTP | 用户认证 |
| Message Queue | AMQP | 异步消息 |
```

## 最佳实践

1. **完整文档**: 文档化所有接口
2. **版本管理**: 管理 API 版本
3. **变更追踪**: 追踪接口变更
4. **测试覆盖**: 确保接口测试覆盖