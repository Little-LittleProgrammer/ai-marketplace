---
name: index-manage
description: This skill should be used when the user needs to manage knowledge indices, rebuild indexes, or optimize search performance.
version: 0.1.0
---

# 索引维护

## 概述

此 Skill 用于维护知识库索引，包括索引重建、优化、一致性检查。

## 索引结构

```
context/
├── index.json          # 总索引
├── index.md            # 可读索引
├── patterns/
│   └── index.json      # 分类索引
├── best-practices/
│   └── index.json
└── ...
```

## 维护操作

### 重建索引

当索引损坏或不一致时重建：
1. 扫描所有知识文件
2. 提取元数据
3. 重新生成索引文件

### 一致性检查

检查索引与实际文件的一致性：
1. 对比索引条目与文件
2. 发现缺失或多余的条目
3. 修复不一致

### 索引优化

优化索引性能：
1. 清理无效条目
2. 更新统计信息
3. 压缩索引文件

## 检查脚本

```bash
# 检查索引一致性
for category in patterns best-practices templates decisions problems; do
  actual=$(ls context/$category/*.md 2>/dev/null | wc -l)
  indexed=$(cat context/$category/index.json 2>/dev/null | grep -c '"id"')
  if [ "$actual" != "$indexed" ]; then
    echo "Mismatch in $category: actual=$actual, indexed=$indexed"
  fi
done
```

## 输出格式

```markdown
## 索引维护报告

### 检查结果
- 总条目: {count}
- 一致性: ✓ / ✗
- 问题数: {count}

### 问题列表
| 类别 | 问题 | 状态 |
|------|------|------|
| | | |

### 修复建议
1. {建议1}
2. {建议2}
```

## 最佳实践

1. **定期检查**: 定期运行一致性检查
2. **自动维护**: 配置自动维护任务
3. **备份恢复**: 保留索引备份
4. **性能监控**: 监控索引性能