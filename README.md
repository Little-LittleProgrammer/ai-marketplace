# QM-AI Workflow

A multi-agent workflow plugin for Claude Code that covers the complete development lifecycle from requirements to delivery.

## Features

- **Intelligent Intent Routing**: phase-router analyzes user input and dispatches to appropriate specialized agents
- **Multi-Agent Collaboration**: 7 specialized agents working together
- **Step-by-Step Confirmation**: Each phase output requires user review before proceeding
- **Memory System**: Leverages AGENT.md and context/ knowledge base for continuous improvement
- **Checkpoint Recovery**: SessionEnd hook saves progress for resume after interruption

## Installation

```bash
# Copy to Claude plugins directory
cp -r qm-ai-workflow ~/.claude/plugins/

# Or use with --plugin-dir
cc --plugin-dir /path/to/qm-ai-workflow
```

## Quick Start

```bash
# Initialize project knowledge (cold start)
/qm-ai:init

# Start a new workflow
/qm-ai:start 帮我开发一个用户认证系统

# Continue to next phase after review
/qm-ai:continue

# Check current status
/qm-ai:status

# Rollback if needed
/qm-ai:rollback

# Optimize workflow and archive knowledge
/qm-ai:optimize-flow
```

## Workflow Phases

| Phase | Output | Command |
|-------|--------|---------|
| Requirements Analysis | spec.md | /qm-ai:start |
| Architecture Design | design.md | /qm-ai:continue |
| Task Breakdown | task.md | /qm-ai:continue |
| Code Development | Source code | /qm-ai:continue |
| Testing | Test code | Auto |
| Knowledge Archive | AGENT.md update | /qm-ai:knowledge |

## Data Storage

```
project/
├── AGENT.md           # Global knowledge
├── requirement/       # Spec, design, task documents
├── context/           # Knowledge base (patterns, templates)
└── workspace/         # Source code
```

## Components

### Agents (7)
- phase-router - Intent recognition and routing
- requirement-manager - Requirements lifecycle
- design-manager - Design lifecycle
- code-executor - Development lifecycle
- frontend-coder - Frontend development
- backend-coder - Backend development
- experience-depositor - Knowledge management

### Skills (21)
- Workflow management, requirement handling, design, development, memory system

### Commands (6)
- /qm-ai:init - Initialize project knowledge (cold start)
- /qm-ai:start - Start workflow
- /qm-ai:continue - Next phase
- /qm-ai:rollback - Rollback
- /qm-ai:status - View status
- /qm-ai:optimize-flow - Optimize workflow and archive knowledge

## License

MIT