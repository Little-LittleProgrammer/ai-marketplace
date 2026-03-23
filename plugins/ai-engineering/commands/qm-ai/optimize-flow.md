---
name: qm-ai:optimize-flow
description: Analyze workflow history and optimize processes, update knowledge base with best practices, and refine AGENT.md with learned patterns
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Edit
  - Agent
  - Skill
---

# 流程优化与知识沉淀

Analyze completed workflows to extract learnings, optimize processes, and update the knowledge base.

**别名**：与 **`/qm-ai:knowledge`** 等价，任选其一即可。

## Instructions

### 0. Skill Routing 

When executing `/qm-ai:optimize-flow`, prioritize skills in the following order:

1. **experience-index (Required)**
   - Retrieve historical experiences from `AGENT.md` and `context/` to locate similar problems and verified solutions.
2. **memory-system (Required)**
   - Validate the target structure for knowledge deposition to ensure update paths and categories are correct.
3. **agents-memory-maintainer (Required)**
   - Ensure incremental updates to `AGENT.md` follow unified structure and maintenance standards.
4. **index-manage (Required)**
   - After updates, execute consistency checks and corrections for `context/index.json`.
5. **mate-maintainer (Optional)**
   - Synchronize metadata maintenance when dealing with category indexing, metadata fields, and entry statistics.
6. **requirement-complete (Optional)**
   - When this optimization is strongly related to "requirement completion retrospective", reuse completion checklist items to refine deposition content.

### 1. Analyze Current Workflow

Read `.qm-ai/state.json` and workflow history to understand:
- Completed phases
- Time spent in each phase
- Rollback history
- Issues encountered

Apply `experience-index` before analysis synthesis:
- Search similar historical workflow outcomes
- Pull reusable lessons from `context/` categories

### 2. Extract Learnings

Identify patterns and learnings from:
- **What worked well**: Successful patterns to reinforce
- **What didn't work**: Areas for improvement
- **Bottlenecks**: Phases that took longer than expected
- **Rework causes**: Why rollbacks occurred

If this optimization happens right after requirement delivery, optionally apply `requirement-complete` checklist to ensure learnings are complete and evidence-based.

### 3. Update Knowledge Base

Update the following based on learnings:

#### AGENT.md
- Add new code patterns discovered
- Update best practices
- Record important decisions
- Document common pitfalls

#### context/patterns/
- Create new pattern files for reusable solutions
- Update existing patterns with refinements

#### context/best-practices/
- Document new best practices
- Refine existing practices

#### context/problems/
- Record problems encountered
- Document solutions applied

Apply maintenance skills during write-back:
- Use `memory-system` to validate target categories and storage paths
- Use `agents-memory-maintainer` to keep AGENT.md structure stable
- Use `mate-maintainer` when metadata (timestamps/counts/tags) changes

### 4. Optimize Workflow

Suggest workflow optimizations:
- Phase sequence adjustments
- Template improvements
- Skill enhancements
- Agent behavior refinements

Finally apply `index-manage`:
- Check index/file consistency after updates
- Repair mismatched counts or stale entries

## Output Format

```markdown
## 流程优化报告

### 工作流分析

**已完成阶段**: [phases]
**回滚次数**: [count]
**总耗时**: [duration]

### 关键发现

#### 做得好的
1. [发现1]
2. [发现2]

#### 需要改进的
1. [改进点1]
2. [改进点2]

#### 瓶颈分析
| 阶段 | 耗时 | 原因 | 建议 |
|------|------|------|------|
| | | | |

### 知识更新

#### AGENT.md 更新
- [ ] [更新项1]
- [ ] [更新项2]

#### 新增模式
- [ ] [模式1]: [描述]

#### 新增最佳实践
- [ ] [实践1]: [描述]

### Skills 调用情况
- [x] experience-index
- [x] memory-system
- [x] agents-memory-maintainer
- [x] index-manage
- [ ] mate-maintainer（按需）
- [ ] requirement-complete（按需）

### 优化建议

1. **流程优化**: [建议]
2. **模板改进**: [建议]
3. **技能增强**: [建议]

### 下次启动检查清单

- [ ] 检查 AGENT.md 是否需要更新
- [ ] 验证模式是否可复用
- [ ] 确认最佳实践是否有效
```

## Example Usage

```
User: /qm-ai:optimize-flow

Response:
## 流程优化报告

### 工作流分析

**已完成阶段**: 需求分析 → 架构设计 → 代码开发 → 测试验证
**回滚次数**: 1 (架构设计阶段)
**总耗时**: 4.5 小时

### 关键发现

#### 做得好的
1. 需求拆分清晰，每个 spec.md 独立可测试
2. API 设计阶段提前考虑了扩展性

#### 需要改进的
1. 设计文档缺少数据库索引规划
2. 测试用例覆盖不够全面

#### 瓶颈分析
| 阶段 | 耗时 | 原因 | 建议 |
|------|------|------|------|
| 架构设计 | 1.5h | 回滚重做 | 增加设计评审环节 |
| 测试验证 | 1h | 用例不全 | 使用测试模板 |

### 知识更新

#### AGENT.md 更新
- [x] 添加 Repository 模式使用规范
- [x] 更新 API 文档模板

#### 新增模式
- [x] 分页查询模式: context/patterns/pagination.md

#### 新增最佳实践
- [x] 设计评审清单: context/best-practices/design-review.md

### Skills 调用情况
- [x] experience-index
- [x] memory-system
- [x] agents-memory-maintainer
- [x] index-manage
- [x] mate-maintainer
- [ ] requirement-complete（未触发）

### 优化建议

1. **流程优化**: 架构设计前增加技术预研阶段
2. **模板改进**: design.md 增加索引设计章节
3. **技能增强**: 测试生成 skill 增加边界用例模板
```

## Knowledge Categories

### Patterns (context/patterns/)
Reusable code patterns and architectural patterns.

### Best Practices (context/best-practices/)
Project-specific best practices and guidelines.

### Problems (context/problems/)
Problems encountered and their solutions.

### Templates (context/templates/)
Document and code templates.

## Error Handling

- **No workflow history**: Report that no completed workflow exists
- **Permission denied**: Report file access issues
- **Empty learnings**: Suggest manual review of workflow