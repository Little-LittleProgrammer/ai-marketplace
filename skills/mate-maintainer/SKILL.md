---
name: mate-maintainer
description: This skill should be used when the user needs to maintain metadata information, update index files, or manage knowledge structure.
version: 0.1.0
---

# 元信息维护

## 概述

此 Skill 用于维护知识库的元信息，包括索引文件更新、分类维护、元数据管理。

## 元信息类型

### 索引元数据
- 知识条目数量
- 更新时间
- 分类信息

### 条目元数据
- 创建时间
- 更新时间
- 标签
- 来源

## 索引文件格式

### context/index.json
```json
{
  "version": "1.0.0",
  "updated_at": "2026-03-16T10:00:00Z",
  "categories": {
    "patterns": {
      "count": 5,
      "path": "patterns/"
    },
    "best-practices": {
      "count": 3,
      "path": "best-practices/"
    }
  }
}
```

### 分类索引格式
```json
{
  "category": "patterns",
  "updated_at": "2026-03-16T10:00:00Z",
  "items": [
    {
      "id": "pattern-001",
      "name": "Repository Pattern",
      "file": "repository-pattern.md",
      "tags": ["design-pattern", "data-access"],
      "created_at": "2026-03-15T10:00:00Z"
    }
  ]
}
```

## 维护操作

### 新增条目
1. 创建知识文件
2. 更新分类索引
3. 更新总索引

### 更新条目
1. 修改知识文件
2. 更新时间戳
3. 更新索引

### 删除条目
1. 移除知识文件
2. 更新索引
3. 清理引用

## 最佳实践

1. **及时更新**: 知识变更时同步更新索引
2. **一致性**: 保持索引与实际文件一致
3. **版本控制**: 使用版本控制管理变更
4. **备份**: 定期备份索引文件