# BMAD Corporate

Multi-agent development workflow plugin for Claude Code. 9 named AI agents with holacracy roles, structured workflows, quality gates, and full customization.

## Quick Start

```bash
# Development: load for current session
claude --plugin-dir /path/to/claude-plugin-bmad-corporate/plugin

# Or install permanently via marketplace
claude plugin marketplace add /path/to/claude-plugin-bmad-corporate
claude plugin install bmad-corporate@bmad-corporate
```

Then in any project:

```bash
/bmad-corporate:bmad-init          # Initialize project
/bmad-corporate:bmad-mary          # Start with requirements
/bmad-corporate:bmad-greenfield    # Or run the full workflow
```

## The Team

| Command | Agent | Role |
|---|---|---|
| `/bmad-corporate:bmad-mary` | Mary | Business Analyst — requirements, user stories |
| `/bmad-corporate:bmad-winston` | Winston | System Architect — design, ADRs, trade-offs |
| `/bmad-corporate:bmad-amelia` | Amelia | Developer — implementation, code review |
| `/bmad-corporate:bmad-murat` | Murat | Test Architect — test strategy, QA, quality gates |
| `/bmad-corporate:bmad-sally` | Sally | UX Expert — UI/UX design, wireframes |
| `/bmad-corporate:bmad-john` | John | Product Manager — PRD, prioritization, roadmap |
| `/bmad-corporate:bmad-bob` | Bob | Scrum Master — sprint planning, coordination |
| `/bmad-corporate:bmad-doris` | Doris | Documentation Specialist — doc generation from templates |

## Review

| Command | Purpose |
|---|---|
| `/bmad-corporate:bmad-code-review` | Multi-agent PR code review with CLAUDE.md compliance (5 parallel reviewers, confidence scoring) |

## Orchestrators

| Command | Purpose |
|---|---|
| `/bmad-corporate:bmad-greenfield` | Full workflow: Mary → John → Sally → Winston → Security → Bob → Amelia → Murat |
| `/bmad-corporate:bmad-sprint` | Interactive sprint planning ceremony (6 steps) |

## Utilities

| Command | Purpose |
|---|---|
| `/bmad-corporate:bmad-init` | Initialize BMAD for current project (includes dependency setup) |
| `/bmad-corporate:bmad-shard` | Split large documents into atomic shards (90% token reduction) |
| `/bmad-corporate:bmad` | Status dashboard |

## Dependencies

All dependencies are **optional** — agents degrade gracefully when missing. `/bmad-init` detects what's installed and offers setup options.

| Dependency | Type | Group | Used By |
|---|---|---|---|
| Linear | Cloud MCP | Core | All agents |
| claude-mem | Plugin | Core | All agents |
| Cupertino | Brew MCP | iOS | Winston, Amelia, Sally |
| SwiftUI Expert | Plugin | iOS | Winston, Amelia, Sally |
| Swift LSP | Plugin | iOS | Amelia |
| Notion | Plugin | Extras | Doris |
| bmad-mcp | npm | Extras | Greenfield |

```bash
# First-time setup (interactive)
bash plugin/resources/scripts/install-deps.sh

# Check status only
bash plugin/resources/scripts/install-deps.sh --check-only

# Update all
bash plugin/resources/scripts/update-deps.sh
```

The dependency manifest is at `plugin/resources/deps-manifest.yaml`. Per-project overrides go in `config.yaml` under the `dependencies:` key.

## Architecture

### Zero Footprint

All BMAD outputs are stored externally — nothing is added to the project repository:

```
~/.claude/bmad/projects/<project>/
├── output/
│   ├── mary/          # Requirements
│   ├── winston/       # Architecture, ADRs
│   ├── amelia/        # Implementation notes
│   ├── code-review/   # PR review reports
│   ├── murat/         # Test plans, reports
│   ├── sally/         # UX designs
│   ├── john/          # PRDs
│   ├── bob/           # Sprint plans
│   └── doris/         # Generated docs
├── shards/            # Context shards
│   ├── requirements/
│   ├── architecture/
│   └── stories/
└── config.yaml        # Per-project overrides
```

### Agent Isolation

Work agents run in `context: fork` — each invocation starts with a clean context window. No context bleed between phases. Orchestrators and interactive workflows run in `context: same` for multi-turn conversation.

### Quality Gates

- **P0 Security Block**: Greenfield orchestrator refuses to advance to implementation if critical security issues are found
- **QA Reject Gate**: If Murat rejects the implementation, the workflow loops back to Amelia for fixes
- **Completeness Check**: Orchestrator verifies output files exist before advancing

### Context Sharding

Large documents (PRD, architecture) can be split into atomic story files:

```bash
/bmad-corporate:bmad-shard                    # Split documents
/bmad-corporate:bmad-amelia STORY-001         # Implement one story at a time
```

Each invocation loads only the relevant shard (~300 tokens instead of ~5000).

### MCP Integration

Agents integrate with MCP servers when available (graceful degradation if not):

| MCP Server | Used By | For |
|---|---|---|
| Linear | All agents | Issue tracking, sprint management |
| Cupertino | Winston, Amelia, Sally | Apple docs, HIG, Swift APIs |
| claude-mem | All agents | Cross-session memory |

## Customization

See [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md) for the full guide.

### Per-Project Config

Create `~/.claude/bmad/projects/<project>/config.yaml`:

```yaml
agents:
  bmad-winston:
    context_files:
      - docs/ARCHITECTURE.md
    extra_instructions: |
      This project uses MVVM+C with Combine.

  bmad-amelia:
    extra_instructions: |
      Use Swift 6 strict concurrency.
```

### Adding Agents

Drop a `SKILL.md` in `plugin/skills/bmad-<name>/`. Auto-discovered.

### Adding Templates

Drop a `.md` in `plugin/resources/templates/docs/` or `software/`.

## Workflows

### New Feature
```
Mary → John → [Sally] → Winston → [Security] → [Bob] → Amelia → Murat
```

### Bug Fix
```
Amelia (analyze) → Winston (review) → Amelia (fix) → Murat (verify)
```

### Code Review
```
Amelia (implement) → Murat (test) → Code Review (multi-agent PR review with CLAUDE.md compliance) → merge
```

## Soul

Every agent operates under shared team principles defined in `plugin/resources/soul.md`:

- **Growth over ego** — ask, learn, iterate
- **Iteration over perfection** — ship something real
- **Impact over activity** — every change moves the needle
- **No gold-plating** — solve the problem at hand
- **No fear-driven engineering** — understand, then act with confidence

## Migration from BMAD-Setup

See [docs/MIGRATION.md](docs/MIGRATION.md).
