---
name: experience-index
description: This skill should be used when the user wants to search historical experience, find similar past projects, or retrieve knowledge from the memory system.
version: 0.1.0
---

# 经验检索

## 概述

此 Skill 用于从记忆系统中检索历史经验，查找相似项目，获取可复用的知识。

## 检索流程

### 1. 分析检索需求

- 理解用户查询意图
- 提取关键词
- 确定检索范围

### 2. 搜索知识库

- 搜索 `AGENTS.md`
- 搜索 `context/patterns/`
- 搜索 `context/best-practices/`
- 搜索 `context/decisions/`

### 3. 整合结果

- 汇总相关经验
- 排序相关性
- 提供参考链接

## 检索方式

### 关键词搜索
```
在 context/ 目录下搜索包含关键词的文件
```

### 分类浏览
```
按知识分类浏览:
- patterns/ - 代码模式
- best-practices/ - 最佳实践
- templates/ - 模板
- decisions/ - 决策记录
- problems/ - 问题解决方案
```

## 输出格式

```markdown
## 检索结果

**查询**: {关键词}
**匹配数**: {数量}

### 相关经验

#### 1. {经验标题}
- **来源**: {文件路径}
- **摘要**: {简短描述}
- **相关度**: 高/中/低

#### 2. {经验标题}
...

### 建议参考
- [ ] {参考项1}
- [ ] {参考项2}
```

## 最佳实践

1. **多维度搜索**: 从多个维度检索
2. **关联分析**: 分析经验间的关联
3. **时效性**: 考虑经验的时效性
4. **验证适用**: 验证经验是否适用当前场景