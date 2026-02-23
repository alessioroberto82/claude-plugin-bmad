# BMAD Plugin

Multi-agent development workflow plugin for Claude Code. 8 holacracy roles with structured workflows, quality gates, and full customization.

## Project Structure

```
plugin/
├── .claude-plugin/
│   ├── plugin.json                     # Plugin manifest (name, version, author)
│   └── marketplace.json                # Marketplace listing metadata
├── commands/
│   └── bmad.md                         # /bmad status dashboard command
├── resources/
│   ├── soul.md                         # Team principles — loaded by all roles
│   ├── deps-manifest.yaml              # Dependency registry (single source of truth)
│   ├── scripts/
│   │   ├── install-deps.sh             # First-time dependency installer
│   │   └── update-deps.sh              # Dependency updater
│   └── templates/
│       ├── config-example.yaml         # Per-project config template
│       ├── docs/                       # Document templates (ADR, module arch, UI)
│       └── software/                   # Software templates (PRD, architecture, security)
└── skills/
    ├── bmad-scope/SKILL.md             # Scope Clarifier
    ├── bmad-arch/SKILL.md              # Architecture Owner
    ├── bmad-impl/SKILL.md              # Implementer
    ├── bmad-qa/SKILL.md                # Quality Guardian
    ├── bmad-ux/SKILL.md                # Experience Designer
    ├── bmad-prioritize/SKILL.md        # Prioritizer
    ├── bmad-facilitate/SKILL.md        # Facilitator
    ├── bmad-docs/SKILL.md              # Documentation Steward
    ├── bmad-code-review/SKILL.md       # Multi-agent PR code review
    ├── bmad-triage/SKILL.md            # PR review comment triage
    ├── bmad-greenfield/SKILL.md        # Full workflow orchestrator
    ├── bmad-sprint/SKILL.md            # Sprint planning orchestrator
    ├── bmad-init/SKILL.md              # Project initialization
    └── bmad-shard/SKILL.md             # Context sharding utility
docs/
├── CUSTOMIZATION.md                    # 8-layer customization guide
├── GETTING-STARTED.md                  # Quick-start guide for new users
└── MIGRATION.md                        # Migration from old BMAD-Setup
```

## Development

Test changes by loading the plugin locally:

```bash
claude --plugin-dir ./plugin
```

There is no build step, no tests, no CI. This is a pure Markdown plugin.

## SKILL.md Format

Every role skill follows this structure:

**YAML Frontmatter:**

```yaml
---
name: bmad-<role>
description: "<Role Name> — <Purpose>."
allowed-tools: Read, Grep, Glob, Bash
metadata:
  context: fork        # fork = isolated subagent | same = main conversation thread
  agent: Explore       # Explore, Plan, qa, or general-purpose
---
```

**Markdown Body (in order):**

1. Soul reference — link to `soul.md` principles
2. Role description — 2-3 sentences defining the role's accountabilities
3. Domain detection — how to detect software/business/personal/general
4. Input prerequisites — what files/outputs to read before starting
5. Domain-specific behavior — different instructions per domain
6. Process — step-by-step execution instructions
7. Handoff — completion message and next role recommendation
8. BMAD principles — core tenets specific to this role

## Conventions

- **Role naming**: `bmad-<lowercase-role>` everywhere (skill dirs, frontmatter, output dirs)
- **Context model**: Use `context: fork` for roles (isolated execution). Use `context: same` for orchestrators and interactive workflows
- **Domain detection**: Roles detect project type by looking for marker files (Package.swift, package.json, etc.) and adjust behavior accordingly
- **Quality gates**: P0 security blocks stop workflow before implementation. QA rejection loops back to the Implementer. Completeness checks verify outputs exist before advancing
- **Zero project footprint**: All BMAD outputs go to `~/.claude/bmad/projects/<project>/`. Nothing is committed to the repo
- **MCP tools are optional**: Roles check for MCP tools (Linear, claude-mem, and domain-specific servers) but degrade gracefully if absent
- **Soul is mandatory**: Every role must reference and follow `plugin/resources/soul.md`
- **Dependencies are optional**: All dependencies are declared in `deps-manifest.yaml`. `bmad-init` detects missing deps and offers installation. Roles degrade gracefully when dependencies are missing
- **Templates live in resources**: Document templates go in `plugin/resources/templates/docs/` or `plugin/resources/templates/software/`
- **Template variants**: Template variants use `-{technology}` suffix (e.g., `-swift`, `-node`). Technology is detected from marker files by `bmad-docs`, distinct from the 4-domain model used by other roles. Base templates are always language-agnostic
- **Domain-agnostic core**: Skills must NOT name-drop specific MCP tools (Cupertino, SwiftUI Expert, etc.) — use "Domain-specific tools" generically. Domain-specific deps live only in `deps-manifest.yaml`
- **Skill suggestions via deps-manifest**: Domain-specific skill suggestions use the `suggest_in` field in `deps-manifest.yaml`, mapping role names to contextual suggestion text. Roles read this field generically — never hardcode skill names in SKILL.md files. To add suggestions for a new domain, add `suggest_in` entries to deps-manifest only
- **Scripts mirror deps-manifest**: `install-deps.sh` and `update-deps.sh` have hardcoded parallel arrays — they do NOT parse `deps-manifest.yaml`. Any dep added to the manifest MUST also be added to both scripts
- **Version bump**: After feature work, update `version` in `plugin/.claude-plugin/plugin.json` before pushing
- **Do not touch for neutralization**: `deps-manifest.yaml`, `bmad-init/SKILL.md`, and `bmad-triage/SKILL.md` contain domain-specific content by design (installer, multi-domain tables). These are correct patterns, not iOS bias
- **docs/MIGRATION.md**: Contains intentional persona name references (Mary, Winston, etc.) for migration mapping — do not remove
- **Holacracy alignment**: Roles have purposes and accountabilities, not personas. Communication references roles, never personal names. External communication uses team voice, not role voice

## Gotchas

- **Marketplace frontmatter validation**: The Luscii marketplace CI (`skills-ref`) only allows `name`, `description`, `allowed-tools`, `compatibility`, `license`, and `metadata` as top-level frontmatter fields. `context` and `agent` must go inside `metadata:`. Keep source repo in sync with marketplace
- **Role vs utility skills**: 8 of the 14 skills are holacracy roles. The rest (greenfield, sprint, code-review, triage, init, shard) are orchestrators or utilities — they coordinate roles but aren't roles themselves
- **marketplace.json is separate from plugin.json**: `plugin.json` is the plugin manifest; `marketplace.json` is for the Claude plugin marketplace listing
- **Output location**: BMAD never writes to the project directory. All outputs go to `~/.claude/bmad/projects/<project>/`. If a role writes to the repo, that's a bug
