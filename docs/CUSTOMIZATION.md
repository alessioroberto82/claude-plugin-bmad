# BMAD Corporate — Customization Guide

This guide explains how to customize every aspect of BMAD Corporate for your team and projects.

## Customization Layers

| Layer | What | Where | Friction |
|---|---|---|---|
| **Soul** | Team principles | `plugin/resources/soul.md` | Edit file, instant effect |
| **Per-project config** | Agent overrides, templates | `~/.claude/bmad/projects/<project>/config.yaml` | Create YAML file |
| **Agent behavior** | Role definitions | `plugin/skills/bmad-<name>/SKILL.md` | Edit SKILL.md |
| **Templates** | Document templates | `plugin/resources/templates/` | Drop .md file |
| **New agent** | Add a team member | `plugin/skills/bmad-<name>/SKILL.md` | Create directory + file |
| **Code review** | PR review with CLAUDE.md compliance | `/bmad-code-review <PR>` | Invoke on any open PR |

---

## 1. Per-Project Configuration

Create `~/.claude/bmad/projects/<project-name>/config.yaml` to customize agent behavior for a specific project.

```yaml
# Override domain detection
domain: software

# Greenfield workflow defaults
greenfield_defaults:
  sally: true
  security: true
  bob: false

# Per-agent overrides
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

See `plugin/resources/templates/config-example.yaml` for a full example.

---

## 2. Adding a New Agent

1. Create the directory: `plugin/skills/bmad-<name>/`
2. Create `SKILL.md` with this template:

```yaml
---
name: bmad-<name>
description: "<Name> — <Role>. <One-line purpose>. <When to use>."
context: fork
agent: general-purpose
allowed-tools: Read, Grep, Glob, Bash
---

# <Name> — <Role>

You are **<Name>**, the <Role> of the BMAD team.

## Soul
Read and embody the principles in `${CLAUDE_PLUGIN_ROOT}/resources/soul.md`.

## Your Identity
<2-3 sentences about perspective and priorities>

## Domain Detection
<Standard domain detection block>

## Input Prerequisites
<What files to read, error if missing>

## Process
1. <Step-by-step execution>
2. <Save output to ~/.claude/bmad/projects/{project}/output/<name>/>

## Handoff
> **<Name> (<Role>) — Complete.**
> Output saved to: <path>
> Next suggested agent: <recommendation>
```

3. Done. Claude Code auto-discovers the skill.
4. Optionally add to `bmad-greenfield/SKILL.md` workflow sequence.

---

## 3. Adding a New Template

1. Drop a `.md` file in the appropriate directory:
   - `plugin/resources/templates/docs/` — for Doris (documentation)
   - `plugin/resources/templates/software/` — for agents (PRD, architecture, etc.)

2. Use `{placeholder}` patterns for dynamic content.

3. Doris will automatically discover and list new templates in the docs/ directory.

---

## 4. Modifying the Soul

Edit `plugin/resources/soul.md`. Changes take effect on the next skill invocation.

The Soul is loaded by every agent and sets the behavioral foundation. Keep it concise and principle-based.

---

## 5. Adding to the Greenfield Workflow

To add a new agent to the greenfield orchestrator:

1. Edit `plugin/skills/bmad-greenfield/SKILL.md`
2. Add the agent to the workflow sequence
3. Add to the "Agent Sequence Detail" table
4. Add checkpoint handling in the execution phase

---

## 6. Context Model Reference

| Context | When to Use | Effect |
|---|---|---|
| `fork` | Work agents (analysis, design, implementation) | Isolated subagent, clean context, no bleed |
| `same` | Orchestrators, interactive workflows, utilities | Runs in main conversation, multi-turn |

---

## 7. Agent Type Reference

| Agent Type | When to Use |
|---|---|
| `Explore` | Discovery, analysis, codebase exploration |
| `Plan` | Architecture, design, planning |
| `qa` | Testing, validation, quality checks |
| `general-purpose` | Implementation, coordination, anything else |

---

## 8. MCP Integration

Agents reference MCP tools (Linear, Cupertino, claude-mem) but degrade gracefully if unavailable. To configure:

- **Linear**: Set up Linear MCP server in Claude Code settings
- **Cupertino**: Set up Cupertino MCP server for Apple docs
- **claude-mem**: Install claude-mem plugin for cross-session memory

Per-project Linear mapping in `config.yaml`:
```yaml
linear:
  team: "iOS"
  project: "My Project"
```
