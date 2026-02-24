# Model Routing for BMAD Agents — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Allow BMAD skills to specify which Claude model (Opus, Sonnet, Haiku) each agent should use, reducing cost on lightweight tasks and reserving Opus for high-reasoning work.

**Architecture:** Explicit model directives in orchestrator skills (bmad-greenfield, bmad-code-review) and in fork-context skills that spawn subagents. Config override via `config.yaml` per-project. No changes to Claude Code internals — uses existing `model` parameter of the Task tool.

**Tech Stack:** Pure Markdown (SKILL.md edits), YAML (config-example.yaml)

---

## Context

### Current State

16 BMAD skills. 7 use `context: fork` (run as subagents), 8 use `context: same` (inline). One skill (bmad-code-review) explicitly spawns 2 parallel Task agents.

**Fork-context skills** (subagent, model selectable):

| Skill | Agent Type | Current Model |
|-------|-----------|---------------|
| bmad-scope | Explore | inherited |
| bmad-prioritize | general-purpose | inherited |
| bmad-ux | Plan | inherited |
| bmad-arch | Plan | inherited |
| bmad-security | qa | inherited |
| bmad-facilitate | general-purpose | inherited |
| bmad-impl | general-purpose | inherited |
| bmad-qa | qa | inherited |

**Same-context skills** (inline, NOT model-selectable):

| Skill | Notes |
|-------|-------|
| bmad-greenfield | Orchestrator — guides user, invokes other skills |
| bmad-code-review | Spawns 2 Task agents (model selectable for those) |
| bmad-tdd | Interactive, runs in conversation |
| bmad-docs | Interactive, runs in conversation |
| bmad-sprint | Interactive, runs in conversation |
| bmad-shard | Utility, runs in conversation |
| bmad-triage | Interactive, runs in conversation |
| bmad-init | Setup, runs in conversation |

### Model Assignment Strategy

| Skill | Recommended Model | Rationale |
|-------|------------------|-----------|
| bmad-scope | sonnet | Structured requirements gathering, pattern work |
| bmad-prioritize | sonnet | Prioritization is structured, not deep reasoning |
| bmad-ux | sonnet | Design patterns, wireframes — structured output |
| bmad-arch | opus | Architecture trade-offs require deep reasoning |
| bmad-security | opus | Threat modeling requires adversarial thinking |
| bmad-facilitate | haiku | Sprint planning is coordination, lightweight |
| bmad-impl | opus | Code generation benefits from best reasoning |
| bmad-qa | sonnet | Validation against defined criteria |
| code-review Agent A | sonnet | Standards checking (already sonnet) |
| code-review Agent B | sonnet | Security scan (already sonnet) |

### Key Constraint

Skills with `context: same` inherit the session model. Only fork-context skills and explicitly spawned Task agents can have their model changed. The orchestrators (greenfield, code-review) run inline but **instruct** users to invoke fork-context skills where model selection takes effect.

---

## Task 1: Add Model Routing to config-example.yaml

**Files:**
- Modify: `plugin/resources/templates/config-example.yaml`

**Step 1: Add model field to agents section**

Add a `model:` field with documentation to the agents config section. After the existing `agents:` block, each agent entry gets a new optional `model` key.

```yaml
# Model routing — assign Claude model per role (opus, sonnet, haiku)
# Roles with context: fork run as subagents and respect this setting.
# Roles with context: same inherit the session model (setting is ignored).
# Default: inherits from session (usually opus).
agents:
  bmad-scope:
    model: sonnet
  bmad-prioritize:
    model: sonnet
  bmad-ux:
    model: sonnet
  bmad-arch:
    model: opus
    context_files:
      - docs/ARCHITECTURE.md
      - docs/ADR/
    extra_instructions: |
      This project uses a layered architecture with dependency injection.
      All new modules must follow the existing pattern.
  bmad-security:
    model: opus
  bmad-facilitate:
    model: haiku
  bmad-impl:
    model: opus
    context_files:
      - src/
    extra_instructions: |
      Follow project coding standards and existing conventions.
      All public APIs must have documentation comments.
  bmad-qa:
    model: sonnet
    extra_instructions: |
      Minimum test coverage target: 80%.
      Focus on integration tests for data flows.
  bmad-ux:
    model: sonnet
    extra_instructions: |
      Follow platform design guidelines.
      Support accessibility features.
```

**Step 2: Add code-review model config**

Add a new section for code-review agent model selection:

```yaml
# Code review agent models (bmad-code-review spawns 2 parallel agents)
code_review:
  agent_a_model: sonnet    # Standards & Bugs
  agent_b_model: sonnet    # Security
```

**Step 3: Commit**

```bash
git add plugin/resources/templates/config-example.yaml
git commit -m "feat: add model routing config to config-example.yaml"
```

---

## Task 2: Add Model Directive to Fork-Context Skills

For each of the 7 fork-context skills, add a `## Model` section that documents the recommended model and instructs the runtime to use it.

**Files:**
- Modify: `plugin/skills/bmad-scope/SKILL.md`
- Modify: `plugin/skills/bmad-prioritize/SKILL.md`
- Modify: `plugin/skills/bmad-ux/SKILL.md`
- Modify: `plugin/skills/bmad-arch/SKILL.md`
- Modify: `plugin/skills/bmad-security/SKILL.md`
- Modify: `plugin/skills/bmad-facilitate/SKILL.md`
- Modify: `plugin/skills/bmad-impl/SKILL.md`
- Modify: `plugin/skills/bmad-qa/SKILL.md`

**Step 1: Add model field to frontmatter metadata**

For each skill, add `model:` to the metadata block. Example for bmad-arch:

```yaml
metadata:
  context: fork
  agent: Plan
  model: opus
```

Full mapping:

| Skill | model value |
|-------|------------|
| bmad-scope | sonnet |
| bmad-prioritize | sonnet |
| bmad-ux | sonnet |
| bmad-arch | opus |
| bmad-security | opus |
| bmad-facilitate | haiku |
| bmad-impl | opus |
| bmad-qa | sonnet |

**Step 2: Add Model section to each skill body**

After the `## Soul` section (or `## Your Identity` if present), add:

```markdown
## Model

**Default model**: {opus|sonnet|haiku}
**Override**: Set `agents.bmad-{name}.model` in project `config.yaml`.
**Rationale**: {one sentence why this model}.

> When invoked by an orchestrator (bmad-greenfield), use the Task tool with `model: "{model}"` unless overridden by config.
```

Example for bmad-arch:

```markdown
## Model

**Default model**: opus
**Override**: Set `agents.bmad-arch.model` in project `config.yaml`.
**Rationale**: Architecture decisions require deep reasoning about trade-offs and system design.

> When invoked by an orchestrator (bmad-greenfield), use the Task tool with `model: "opus"` unless overridden by config.
```

Example for bmad-facilitate:

```markdown
## Model

**Default model**: haiku
**Override**: Set `agents.bmad-facilitate.model` in project `config.yaml`.
**Rationale**: Sprint coordination is structured and lightweight, does not require deep reasoning.

> When invoked by an orchestrator (bmad-greenfield), use the Task tool with `model: "haiku"` unless overridden by config.
```

**Step 3: Commit**

```bash
git add plugin/skills/bmad-*/SKILL.md
git commit -m "feat: add model routing directives to all fork-context skills"
```

---

## Task 3: Update bmad-greenfield Orchestrator

**Files:**
- Modify: `plugin/skills/bmad-greenfield/SKILL.md`

**Step 1: Add Model Routing section**

After the `## Domain Detection` section (line ~48), add:

```markdown
## Model Routing

Each role runs with a recommended Claude model. The orchestrator passes the `model` parameter when presenting role invocations. Users can override per-project in `config.yaml`.

| Role | Default Model | Rationale |
|------|--------------|-----------|
| Scope Clarifier | sonnet | Structured requirements gathering |
| Prioritizer | sonnet | Feature prioritization |
| Experience Designer | sonnet | UX design patterns |
| Architecture Owner | opus | Deep trade-off reasoning |
| Security Guardian | opus | Adversarial threat modeling |
| Facilitator | haiku | Lightweight coordination |
| Implementer | opus | Code generation quality |
| Quality Guardian | sonnet | Criteria-based validation |

**Config override**: `agents.bmad-{name}.model` in `~/.claude/bmad/projects/{project}/config.yaml`
```

**Step 2: Update Role Sequence Detail table**

Add a "Model" column to the existing table (line ~159):

```markdown
| Step | Role | Model | Purpose | Input | Output |
|---|---|---|---|---|---|
| 1 | **Scope Clarifier** | sonnet | Gather requirements | User description | `scope/requirements.md` |
| 2 | **Prioritizer** | sonnet | Prioritize & create PRD | Requirements | `prioritize/PRD.md` |
| 3* | **Experience Designer** | sonnet | Design UX | PRD | `ux/ux-design.md` |
| 4 | **Architecture Owner** | opus | Design architecture | PRD + UX (if available) | `arch/architecture.md` |
| 5* | **Security Guardian** | opus | Security audit | Architecture | `security/security-audit.md` |
| 6* | **Facilitator** | haiku | Sprint planning | PRD + Architecture | `facilitate/sprint-plan.md` |
| 7 | **Implementer** | opus | Implement | Architecture + PRD | Code in repo |
| 8 | **Quality Guardian** | sonnet | Test & validate | Requirements + Code | `qa/test-report.md` |
```

**Step 3: Update Step Display template**

Add model info to the step display block (line ~138):

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Step {N}/{total}: {Role Name} [{model}]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Purpose: {What this role will do}
Model: {opus|sonnet|haiku} (override in config.yaml)
Input: {What artifacts from previous steps are available}
Output: {What artifact this role will produce}

Please invoke the role:
→ /bmad:bmad-{name}

After completion, type one of:
  next  — proceed to next step
  skip  — skip this step (optional phases only)
  pause — save progress and exit
  back  — return to previous step
  exit  — exit workflow
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Step 4: Update session-state.json schema**

Add model_routing to the workflow object in the init template (line ~100):

```json
"model_routing": {
  "bmad-scope": "sonnet",
  "bmad-prioritize": "sonnet",
  "bmad-ux": "sonnet",
  "bmad-arch": "opus",
  "bmad-security": "opus",
  "bmad-facilitate": "haiku",
  "bmad-impl": "opus",
  "bmad-qa": "sonnet"
}
```

**Step 5: Commit**

```bash
git add plugin/skills/bmad-greenfield/SKILL.md
git commit -m "feat: add model routing to greenfield orchestrator"
```

---

## Task 4: Update bmad-code-review Model Directives

**Files:**
- Modify: `plugin/skills/bmad-code-review/SKILL.md`

**Step 1: Replace hardcoded "Sonnet" with configurable model reference**

Change line 42 from:
```
Launch **2 parallel Sonnet agents in a single message**.
```
To:
```
Launch **2 parallel agents in a single message** (default: sonnet; override via `code_review.agent_a_model` and `code_review.agent_b_model` in config.yaml).
```

**Step 2: Add model parameter to agent launch instructions**

After the confidence scale section, add:

```markdown
**Model selection**: Pass `model: "sonnet"` (or config override) to each Task tool invocation. Use Sonnet for both agents by default — code review is pattern-matching work that doesn't require Opus-level reasoning.
```

**Step 3: Commit**

```bash
git add plugin/skills/bmad-code-review/SKILL.md
git commit -m "feat: make code-review agent models configurable"
```

---

## Task 5: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

**Step 1: Add model routing to Rules section**

Add after the **TDD** rule:

```markdown
**Model routing**: Fork-context skills specify a default model (opus/sonnet/haiku) in frontmatter `metadata.model`. Orchestrators pass the `model` parameter to Task tool. Override per-project in `config.yaml` under `agents.<name>.model`. Same-context skills inherit the session model.
```

**Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: add model routing rule to CLAUDE.md"
```

---

## Task 6: Update Documentation

**Files:**
- Modify: `docs/CUSTOMIZATION.md`

**Step 1: Add Model Routing section**

Add a new `## Model Routing` section to CUSTOMIZATION.md explaining:
- What model routing is
- Default assignments table
- How to override via config.yaml
- Which skills support it (fork-context only)
- Cost implications (Opus ~5x Sonnet, Haiku ~25x cheaper than Opus)

**Step 2: Commit**

```bash
git add docs/CUSTOMIZATION.md
git commit -m "docs: add model routing section to CUSTOMIZATION.md"
```

---

## Task 7: Version Bump

**Files:**
- Modify: `plugin/.claude-plugin/plugin.json` — bump to 0.6.0

**Step 1: Bump version**

Change version from `"0.5.1"` to `"0.6.0"` (new feature = minor bump).

**Step 2: Commit**

```bash
git add plugin/.claude-plugin/plugin.json
git commit -m "chore: bump version to 0.6.0"
```

> **Note**: After merge, sync `marketplace.json` AND Luscii/claude-marketplace. Three places must match (per CLAUDE.md rules).

---

## Verification Checklist

After all tasks:
- [ ] All 8 fork-context skills have `model:` in frontmatter metadata
- [ ] All 8 fork-context skills have `## Model` section in body
- [ ] bmad-greenfield has Model Routing section and updated Role Sequence table
- [ ] bmad-code-review no longer hardcodes "Sonnet" — uses configurable model
- [ ] config-example.yaml has `model:` field in agents section
- [ ] CLAUDE.md has model routing rule
- [ ] CUSTOMIZATION.md has model routing documentation
- [ ] plugin.json version is 0.6.0
- [ ] No same-context skills were modified (they can't change model)

## Risk Notes

- **Frontmatter `model:` field may be ignored by Claude Code runtime** — the explicit Task tool `model` parameter in orchestrator instructions is the guaranteed mechanism. The frontmatter field is aspirational/documentary.
- **Haiku for bmad-facilitate** may produce lower quality sprint plans — monitor and upgrade to sonnet if needed.
- **Config override** requires the orchestrator skill to read config.yaml and respect overrides — this is an instruction to the LLM, not enforced by code.
