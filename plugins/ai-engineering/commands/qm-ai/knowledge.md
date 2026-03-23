---
name: qm-ai:knowledge
description: Knowledge deposition and workflow retrospective (alias of /qm-ai:optimize-flow)
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Edit
  - Agent
  - Skill
---

# 知识沉淀

本命令与 **`/qm-ai:optimize-flow` 完全等价**：复盘工作流、更新 AGENT.md 与 `context/` 知识库。维护时请与 `optimize-flow.md` 保持 Instructions 同步。

## Instructions

### 0. Skill Routing

When executing `/qm-ai:knowledge`, prioritize skills in the following order:

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

与 `optimize-flow.md` 中 **## Output Format** 章节相同（流程优化报告结构）。

## Error Handling

- **No workflow history**: Report that no completed workflow exists
- **Permission denied**: Report file access issues
- **Empty learnings**: Suggest manual review of workflow
