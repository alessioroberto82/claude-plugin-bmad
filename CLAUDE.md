# BMAD Corporate Plugin

Multi-agent development workflow plugin for Claude Code. 9 named AI agents with holacracy roles, structured workflows, quality gates, and full customization.

## Project Structure

```
plugin/
├── .claude-plugin/
│   └── plugin.json                     # Plugin manifest (name, version, author)
├── commands/
│   └── bmad.md                         # /bmad status dashboard command
├── resources/
│   ├── soul.md                         # Team principles — loaded by all agents
│   ├── deps-manifest.yaml              # Dependency registry (single source of truth)
│   ├── scripts/
│   │   ├── install-deps.sh             # First-time dependency installer
│   │   └── update-deps.sh              # Dependency updater
│   └── templates/
│       ├── config-example.yaml         # Per-project config template
│       ├── docs/                       # Document templates (ADR, module arch, UI)
│       └── software/                   # Software templates (PRD, architecture, security)
└── skills/
    ├── bmad-mary/SKILL.md              # Business Analyst
    ├── bmad-winston/SKILL.md           # System Architect
    ├── bmad-amelia/SKILL.md            # Developer
    ├── bmad-murat/SKILL.md             # Test Architect
    ├── bmad-sally/SKILL.md             # UX Expert
    ├── bmad-john/SKILL.md              # Product Manager
    ├── bmad-bob/SKILL.md               # Scrum Master
    ├── bmad-doris/SKILL.md             # Documentation Specialist
    ├── bmad-code-review/SKILL.md        # Multi-agent PR code review
    ├── bmad-greenfield/SKILL.md        # Full workflow orchestrator
    ├── bmad-sprint/SKILL.md            # Sprint planning orchestrator
    └── bmad-shard/SKILL.md             # Context sharding utility
docs/
├── CUSTOMIZATION.md                    # 8-layer customization guide
└── MIGRATION.md                        # Migration from old BMAD-Setup
```

## Development

Test changes by loading the plugin locally:

```bash
claude --plugin-dir ./plugin
```

There is no build step, no tests, no CI. This is a pure Markdown plugin.

## SKILL.md Format

Every agent skill follows this structure:

**YAML Frontmatter:**

```yaml
---
name: bmad-<agent>
description: "<Name> — <Role>. <Purpose>."
context: fork          # fork = isolated subagent | same = main conversation thread
agent: Explore         # Explore, Plan, qa, or general-purpose
allowed-tools: Read, Grep, Glob, Bash
---
```

**Markdown Body (in order):**

1. Soul reference — link to `soul.md` principles
2. Identity — 2-3 sentences defining the agent's persona
3. Domain detection — how to detect software/business/personal/general
4. Input prerequisites — what files/outputs to read before starting
5. Domain-specific behavior — different instructions per domain
6. Process — step-by-step execution instructions
7. Handoff — completion message and next agent recommendation
8. BMAD principles — core tenets specific to this agent's role

## Conventions

- **Agent naming**: `bmad-<lowercase-name>` everywhere (skill dirs, frontmatter, output dirs)
- **Context model**: Use `context: fork` for agents (isolated execution). Use `context: same` for orchestrators and interactive workflows
- **Domain detection**: Agents detect project type by looking for marker files (Package.swift, package.json, etc.) and adjust behavior accordingly
- **Quality gates**: P0 security blocks stop workflow before implementation. QA rejection loops back to developer. Completeness checks verify outputs exist before advancing
- **Zero project footprint**: All BMAD outputs go to `~/.claude/bmad/projects/<project>/`. Nothing is committed to the repo
- **MCP tools are optional**: Agents check for Linear, Cupertino, claude-mem availability but degrade gracefully if absent
- **Soul is mandatory**: Every agent must reference and follow `plugin/resources/soul.md`
- **Templates live in resources**: Document templates go in `plugin/resources/templates/docs/` or `plugin/resources/templates/software/`
