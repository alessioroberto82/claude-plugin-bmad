# BMAD → Circle Rename Design

**Goal:** Rename the plugin from "BMAD" to "Circle" — aligning the name with holacracy's core concept (a circle of roles with distributed authority).

## Decisions

| Aspect | Before | After |
|---|---|---|
| Plugin name | `bmad` | `circle` |
| Skill prefix | `bmad-scope`, `bmad-arch` | `scope`, `arch` (no prefix) |
| User commands | `/bmad:bmad-scope` | `/circle:scope` |
| Output path | `~/.claude/bmad/projects/` | `~/.claude/circle/projects/` |
| Config keys | `agents.bmad-scope` | `agents.scope` |
| Repo name | `claude-plugin-bmad` | `claude-plugin-circle` |
| Marketplace name | `bmad` | `circle` |
| Data migration | N/A | None — clean start |

## Scope of Changes

### Manifests
- `plugin/.claude-plugin/plugin.json` — name, keywords, repository URL
- `.claude-plugin/marketplace.json` — name, repository URL

### Skill Directories (17 renames)
| Before | After |
|---|---|
| `plugin/skills/bmad-arch/` | `plugin/skills/arch/` |
| `plugin/skills/bmad-code-review/` | `plugin/skills/code-review/` |
| `plugin/skills/bmad-cycle/` | `plugin/skills/cycle/` |
| `plugin/skills/bmad-docs/` | `plugin/skills/docs/` |
| `plugin/skills/bmad-facilitate/` | `plugin/skills/facilitate/` |
| `plugin/skills/bmad-greenfield/` | `plugin/skills/greenfield/` |
| `plugin/skills/bmad-impl/` | `plugin/skills/impl/` |
| `plugin/skills/bmad-init/` | `plugin/skills/init/` |
| `plugin/skills/bmad-prioritize/` | `plugin/skills/prioritize/` |
| `plugin/skills/bmad-qa/` | `plugin/skills/qa/` |
| `plugin/skills/bmad-scope/` | `plugin/skills/scope/` |
| `plugin/skills/bmad-security/` | `plugin/skills/security/` |
| `plugin/skills/bmad-shard/` | `plugin/skills/shard/` |
| `plugin/skills/bmad-tdd/` | `plugin/skills/tdd/` |
| `plugin/skills/bmad-triage/` | `plugin/skills/triage/` |
| `plugin/skills/bmad-ux/` | `plugin/skills/ux/` |
| `plugin/skills/bmad-validate-prd/` | `plugin/skills/validate-prd/` |

### Skill Content (17 files)
Each SKILL.md:
- Frontmatter `name:` field — remove `bmad-` prefix
- All `/bmad:bmad-*` command references → `/circle:*`
- All `bmad-*` role references in config keys → unprefixed
- Output paths `~/.claude/bmad/` → `~/.claude/circle/`
- Config references `agents.bmad-*` → `agents.*`

### Command File
- `plugin/commands/bmad.md` → `plugin/commands/circle.md`
- All internal references updated

### Resources
- `soul.md` — "BMAD" → "Circle" in prose
- `guardrails.md` — same
- `deps-manifest.yaml` — `bmad-*` references
- `config-example.yaml` — `bmad-*` config keys
- `install-deps.sh`, `update-deps.sh` — path references

### Templates
- `software/PRD.md`, `architecture.md`, `security-audit.md` — any "BMAD" references

### Documentation
- `README.md` — full rewrite of references
- `docs/CHANGELOG.md` — add v1.0.0 entry, keep BMAD history
- `docs/GETTING-STARTED.md` — all commands and references
- `docs/CUSTOMIZATION.md` — config examples
- `CLAUDE.md` — rules and layout

### External
- GitHub: rename repo `claude-plugin-bmad` → `claude-plugin-circle`
- Marketplace: update `Luscii/claude-marketplace` entry

## Breaking Changes

- All user commands change: `/bmad:bmad-*` → `/circle:*`
- Output directory moves: `~/.claude/bmad/` → `~/.claude/circle/`
- Config keys change: `agents.bmad-*` → `agents.*`
- Repo URL changes (GitHub auto-redirects)
- No migration — users re-run `/circle:init` for clean setup

## Version

This is a major breaking change. Bump to **v1.0.0**.

## Naming Convention

After rename, the CLAUDE.md rule changes from:
> `bmad-<lowercase>` everywhere

To:
> `<lowercase>` skill names, `circle` as plugin namespace
