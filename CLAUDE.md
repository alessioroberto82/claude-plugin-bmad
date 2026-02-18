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

<!-- BMAD-INJECT-START -->

---

## BMAD Agents & Workflows

### Configuration

**BMAD is 100% external** — No files or folders in the project repository.

**All BMAD files are in home directory**: `~/.claude/bmad/`

```
~/.claude/bmad/
├── config.json                                    # Agent configuration
├── cache/                                         # Agent context cache
├── logs/                                          # Operation logs
└── projects/
    └── claude-plugin-bmad-corporate/
        ├── output/                                # Agent outputs for this project
        │   ├── mary/                              # Business Analyst
        │   ├── winston/                           # System Architect
        │   ├── amelia/                            # Developer
        │   ├── murat/                             # Test Architect
        │   ├── sally/                             # UX Expert
        │   ├── john/                              # Product Manager
        │   └── bob/                               # Scrum Master
        └── workspace/                             # Temporary workspace
```

**Nothing is tracked in Git** — Zero project modifications required.

### Available Agents

| Agent | Role | Use When | Available Tools |
|-------|------|----------|-----------------|
| **Mary** | Business Analyst | Clarifying requirements, breaking down user stories | Linear, claude-mem |
| **Winston** | System Architect | Deciding architecture, reviewing system design | Cupertino, SwiftUI Expert, Linear, claude-mem |
| **Amelia** | Developer | Implementing code, debugging, code review | Cupertino, SwiftUI Expert, Linear, claude-mem |
| **John** | Product Manager | Prioritizing features, planning roadmap | Linear (full access), claude-mem |
| **Bob** | Scrum Master | Planning sprints, coordinating team | Linear, claude-mem |
| **Murat** | Test Architect | Planning testing strategy, QA oversight | Cupertino, Linear, claude-mem |
| **Sally** | UX Expert | UI/UX design, user experience decisions | Cupertino, SwiftUI Expert, Linear, claude-mem |
| **Doris** | Documentation Specialist | Template parsing, docs generation | Linear, claude-mem |

### Standard Workflows

#### 1. **New Feature Workflow**
```
1. Mary: Gather and validate requirements
2. Winston: Design system architecture
3. Sally: Design UI/UX mockups
4. Murat: Plan testing strategy
5. Amelia: Implement the feature
6. Amelia: Code review and cleanup
7. Murat: Execute testing and QA
```

**Usage**:
```bash
/ask mary gather-requirements "Feature description"
/ask winston design-architecture
/ask sally design-ui "Feature name"
/ask murat plan-testing "Feature scope"
# Implementation happens here
/ask amelia implement
/ask amelia review-code
/ask murat verify-tests
```

#### 2. **Bug Fix Workflow**
```
1. Amelia: Analyze and understand the bug
2. Winston: Review architecture implications
3. Amelia: Implement the fix
4. Murat: Verify fix doesn't break tests
5. Amelia: Final code review
```

**Usage**:
```bash
/ask amelia analyze-bug "Bug description"
/ask winston review-implications
# Fix implementation
/ask murat verify-fix
/ask amelia final-review
```

#### 3. **Refactoring Workflow**
```
1. Winston: Analyze current architecture
2. Amelia: Plan refactoring approach
3. Amelia: Implement changes
4. Murat: Verify all tests pass
5. Amelia: Code review and documentation
```

**Usage**:
```bash
/ask winston analyze-architecture "Area to refactor"
/ask amelia plan-refactoring
# Refactoring happens here
/ask murat verify-tests
/ask amelia document-changes
```

#### 4. **Code Review Workflow** (Pre-Merge)
```
1. Amelia: Primary code review
2. Winston: Architecture review
3. Murat: Test coverage review
4. Sally: UI/UX review (if applicable)
```

**Usage**:
```bash
/ask amelia review-pull-request "PR description"
/ask winston review-architecture
/ask murat review-test-coverage
/ask sally review-ui "If UI changes present"
```

### Output Location

All BMAD outputs are saved to home directory (never in the project):
- **Agent outputs**: `~/.claude/bmad/projects/claude-plugin-bmad-corporate/output/[agent-name]/`
- **Workspace**: `~/.claude/bmad/projects/claude-plugin-bmad-corporate/workspace/`
- **Cache**: `~/.claude/bmad/cache/`
- **Logs**: `~/.claude/bmad/logs/`

**Zero files in project repository** — everything is external.

### Cleanup Before Merge

**No cleanup needed!** All BMAD files are already outside the project.

```bash
# Verify no BMAD files in project
git status  # Should show only code changes

# Commit and push
git add .
git commit -m "Implementation complete"
git push
```

### Best Practices

1. **Start with Mary** — Always clarify requirements first with Business Analyst
2. **Get Winston early** — Architectural decisions before coding saves rework
3. **Use Murat throughout** — Test strategy from start, not at end
4. **Chain agent workflows** — Output from one agent informs the next
5. **Review outputs in home directory** — `~/.claude/bmad/projects/claude-plugin-bmad-corporate/output/`
6. **Multi-agent review** — Use multiple agents for thorough code review
7. **Follow the Soul** — All agents operate under the team's core principles:
   Growth over ego, Iteration over perfection, Impact over activity.
   No gold-plating, no fear-driven engineering. See `~/Documents/BMAD-Setup/soul.md`
8. **Use Linear for traceability** — Link requirements, architecture, and implementation to Linear issues
9. **Search memory first** — Check claude-mem for past decisions before re-solving problems

### Example Session

```markdown
## Task: Implement Feature

### Phase 1: Analysis
- Mary gathered requirements → `~/.claude/bmad/projects/claude-plugin-bmad-corporate/output/mary/requirements.md`
- Winston designed architecture → `~/.claude/bmad/projects/claude-plugin-bmad-corporate/output/winston/architecture.md`
- Sally mocked UI → `~/.claude/bmad/projects/claude-plugin-bmad-corporate/output/sally/ui-mockups.md`
- Murat planned tests → `~/.claude/bmad/projects/claude-plugin-bmad-corporate/output/murat/test-plan.md`

### Phase 2: Implementation
- Amelia implemented feature → Code in repo (tracked)
- Amelia self-reviewed → `~/.claude/bmad/projects/claude-plugin-bmad-corporate/output/amelia/self-review.md`
- Murat verified tests → `~/.claude/bmad/projects/claude-plugin-bmad-corporate/output/murat/test-verification.md`

### Phase 3: Final Review
- Amelia final review → `~/.claude/bmad/projects/claude-plugin-bmad-corporate/output/amelia/final-review.md`
- Winston verified architecture → `~/.claude/bmad/projects/claude-plugin-bmad-corporate/output/winston/final-review.md`
- Murat coverage check → `~/.claude/bmad/projects/claude-plugin-bmad-corporate/output/murat/coverage-report.md`

### Merge
- All BMAD files in home directory (not in repo)
- Only code changes committed to Git
```

<!-- BMAD-INJECT-END -->
