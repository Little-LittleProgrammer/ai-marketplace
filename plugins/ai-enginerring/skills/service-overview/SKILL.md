---
name: service-overview
description: This skill should be used when the user wants to understand a service's overall structure, get an overview of existing codebase, or analyze service boundaries.
version: 0.1.0
---

# 服务概览

## 概述

此 Skill 用于分析现有服务的整体结构，了解服务边界和职责。

## 分析内容

### 1. 服务定位
- 服务名称和职责
- 核心功能
- 服务边界

### 2. 技术栈
- 使用的框架和库
- 数据存储
- 通信方式

### 3. 目录结构
- 代码组织方式
- 模块划分
- 配置管理

## 分析流程

### 1. 入口分析
- 找到服务入口文件
- 分析启动流程
- 识别主要组件

### 2. 模块分析
- 识别功能模块
- 分析模块依赖
- 理解模块职责

### 3. 接口分析
- API 端点
- 数据流
- 接口契约

## 输出格式

```markdown
## 服务概览

### 基本信息
- **服务名称**: {name}
- **技术栈**: {tech}
- **职责**: {responsibility}

### 目录结构
```
{service}/
├── src/
│   ├── modules/
│   ├── shared/
│   └── index.ts
├── config/
├── tests/
└── package.json
```

### 核心模块
| 模块 | 职责 | 主要文件 |
|------|------|----------|
| | | |

### 依赖服务
| 服务 | 用途 | 通信方式 |
|------|------|----------|
| | | |

### 技术债务
- [ ] {债务项}
```

## 最佳实践

1. **快速理解**: 快速建立服务整体认知
2. **边界清晰**: 明确服务边界
3. **依赖识别**: 识别服务依赖关系
4. **文档更新**: 更新服务文档