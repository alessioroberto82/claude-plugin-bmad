# Circle Rename Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Rename the plugin from "BMAD" / "bmad" to "Circle" / "circle", removing the `bmad-` prefix from all skill names.

**Architecture:** Pure find-and-replace across Markdown, JSON, YAML, and shell files. No code logic changes. Each task targets one logical group of files. Verification via grep sweeps after each task.

**Tech Stack:** Markdown, JSON, YAML, Bash scripts. Git for version control.

---

### Task 1: Rename Skill Directories

Rename all 17 `plugin/skills/bmad-*` directories to remove the `bmad-` prefix.

**Files:**
- Rename: `plugin/skills/bmad-arch/` → `plugin/skills/arch/`
- Rename: `plugin/skills/bmad-code-review/` → `plugin/skills/code-review/`
- Rename: `plugin/skills/bmad-cycle/` → `plugin/skills/cycle/`
- Rename: `plugin/skills/bmad-docs/` → `plugin/skills/docs/`
- Rename: `plugin/skills/bmad-facilitate/` → `plugin/skills/facilitate/`
- Rename: `plugin/skills/bmad-greenfield/` → `plugin/skills/greenfield/`
- Rename: `plugin/skills/bmad-impl/` → `plugin/skills/impl/`
- Rename: `plugin/skills/bmad-init/` → `plugin/skills/init/`
- Rename: `plugin/skills/bmad-prioritize/` → `plugin/skills/prioritize/`
- Rename: `plugin/skills/bmad-qa/` → `plugin/skills/qa/`
- Rename: `plugin/skills/bmad-scope/` → `plugin/skills/scope/`
- Rename: `plugin/skills/bmad-security/` → `plugin/skills/security/`
- Rename: `plugin/skills/bmad-shard/` → `plugin/skills/shard/`
- Rename: `plugin/skills/bmad-tdd/` → `plugin/skills/tdd/`
- Rename: `plugin/skills/bmad-triage/` → `plugin/skills/triage/`
- Rename: `plugin/skills/bmad-ux/` → `plugin/skills/ux/`
- Rename: `plugin/skills/bmad-validate-prd/` → `plugin/skills/validate-prd/`

**Step 1: Rename all directories**

```bash
cd plugin/skills
for dir in bmad-*/; do
  new="${dir#bmad-}"
  git mv "$dir" "$new"
done
```

**Step 2: Verify**

```bash
ls plugin/skills/
# Expected: arch/ code-review/ cycle/ docs/ facilitate/ greenfield/ impl/ init/ prioritize/ qa/ scope/ security/ shard/ tdd/ triage/ ux/ validate-prd/
# No bmad-* directories should remain
```

**Step 3: Commit**

```bash
git add -A plugin/skills/
git commit -m "refactor: rename skill directories (remove bmad- prefix)"
```

---

### Task 2: Update Skill Frontmatter and Internal References

Update all 17 SKILL.md files: frontmatter `name:` field and all internal references.

**Files:**
- Modify: all `plugin/skills/*/SKILL.md` (17 files)

**Changes per file:**
1. Frontmatter `name: bmad-<x>` → `name: <x>`
2. All `BMAD circle` → `Circle` (in role descriptions)
3. All `/bmad:bmad-<x>` → `/circle:<x>` (in handoff messages, suggestions)
4. All `~/.claude/bmad/` → `~/.claude/circle/` (in output paths)
5. All `agents.bmad-<x>` → `agents.<x>` (in config references)
6. All `bmad-<x>.model` → `<x>.model` (in model override references)
7. Keep `bmad-mcp` as-is (it's an external npm package name, not ours to rename)

**Step 1: For each SKILL.md, apply replacements**

Pattern replacements (in order of specificity to avoid double-replacing):
- `name: bmad-` → `name: ` (frontmatter only, line 2)
- `/bmad:bmad-` → `/circle:` (command references)
- `agents.bmad-` → `agents.` (config key references)
- `bmad-mcp` → protect (do NOT change)
- `the BMAD circle` → `the Circle` / `in the BMAD circle` → `in the Circle`
- `~/.claude/bmad/` → `~/.claude/circle/`
- `BMAD` → `Circle` in prose (but NOT in "bmad-mcp" or historical changelog references)

**Step 2: Verify no stale `bmad` references remain (except bmad-mcp)**

```bash
grep -r "bmad" plugin/skills/ --include="*.md" | grep -v "bmad-mcp" | grep -v "BMAD MCP"
# Expected: empty (no results)
```

**Step 3: Commit**

```bash
git add plugin/skills/
git commit -m "refactor: update all SKILL.md files for Circle namespace"
```

---

### Task 3: Rename Command File

Rename `plugin/commands/bmad.md` → `plugin/commands/circle.md` and update its content.

**Files:**
- Rename: `plugin/commands/bmad.md` → `plugin/commands/circle.md`

**Step 1: Rename file**

```bash
git mv plugin/commands/bmad.md plugin/commands/circle.md
```

**Step 2: Update content**

Replace in `plugin/commands/circle.md`:
- Title: `# BMAD — Status Dashboard` → `# Circle — Status Dashboard`
- All `/bmad-` → `/circle:` in command display (note: dashboard shows commands without plugin prefix internally)
- All `~/.claude/bmad/` → `~/.claude/circle/`
- All `BMAD` → `Circle` in prose
- Dashboard command references: `/bmad-scope` → `/circle:scope`, etc.
- The `/bmad` command itself references become `/circle`

**Step 3: Verify**

```bash
grep -i "bmad" plugin/commands/circle.md | grep -v "bmad-mcp"
# Expected: empty
```

**Step 4: Commit**

```bash
git add plugin/commands/
git commit -m "refactor: rename command file bmad.md → circle.md"
```

---

### Task 4: Update Plugin Manifests

Update both plugin.json and marketplace.json.

**Files:**
- Modify: `plugin/.claude-plugin/plugin.json`
- Modify: `.claude-plugin/marketplace.json`

**Step 1: Update plugin.json**

```json
{
  "name": "circle",
  "version": "1.0.0",
  "description": "Holacracy-based development workflow with distributed roles, quality gates, and Shape Up planning",
  "author": {
    "name": "Alessio Roberto",
    "url": "https://github.com/alessioroberto82"
  },
  "repository": "https://github.com/alessioroberto82/claude-plugin-circle",
  "license": "MIT",
  "keywords": [
    "circle",
    "holacracy",
    "workflow",
    "development",
    "quality-gates",
    "cycle-planning",
    "shape-up",
    "code-review"
  ]
}
```

**Step 2: Update marketplace.json**

```json
{
  "name": "circle",
  "owner": {
    "name": "Alessio Roberto"
  },
  "metadata": {
    "description": "Circle: Holacracy-based development workflow with distributed roles"
  },
  "plugins": [
    {
      "name": "circle",
      "version": "1.0.0",
      "source": "./plugin",
      "description": "17 skills (9 holacracy roles + 8 utilities) with structured workflows, quality gates, self-verification guardrails, anti-overcomplication checks, TDD enforcement, security audits, and full customization"
    }
  ]
}
```

**Step 3: Commit**

```bash
git add plugin/.claude-plugin/plugin.json .claude-plugin/marketplace.json
git commit -m "refactor: update manifests for Circle rename (v1.0.0)"
```

---

### Task 5: Update Resources

Update soul.md, guardrails.md, deps-manifest.yaml, config-example.yaml.

**Files:**
- Modify: `plugin/resources/soul.md`
- Modify: `plugin/resources/guardrails.md`
- Modify: `plugin/resources/deps-manifest.yaml`
- Modify: `plugin/resources/templates/config-example.yaml`

**Step 1: soul.md**

- `This plugin operates` → keep as-is (no "BMAD" in soul.md, already neutral)
- Verify: `grep -i bmad plugin/resources/soul.md` should be empty

**Step 2: guardrails.md**

Replace:
- `| bmad-arch |` → `| arch |` (all table entries)
- `| bmad-impl |` → `| impl |`
- `| bmad-qa |` → `| qa |`
- `| bmad-prioritize |` → `| prioritize |`
- `| bmad-ux |` → `| ux |`
- `| bmad-security |` → `| security |`
- `~/.claude/bmad/` → `~/.claude/circle/`

**Step 3: deps-manifest.yaml**

Replace:
- `# BMAD — Dependency Manifest` → `# Circle — Dependency Manifest`
- `# Reference for: install-deps.sh, update-deps.sh, bmad-init, bmad-arch, bmad-impl, bmad-qa.` → `# Reference for: install-deps.sh, update-deps.sh, init, arch, impl, qa.`
- `# Override per-project in ~/.claude/bmad/` → `~/.claude/circle/`
- `used_by:` entries: remove `bmad-` prefixes where present
- Keep `bmad-mcp` as-is (external package name)
- `"BMAD MCP server"` → `"Circle MCP server"` (description text)

**Step 4: config-example.yaml**

Replace:
- `# BMAD — Per-Project Configuration` → `# Circle — Per-Project Configuration`
- `# Copy this file to: ~/.claude/bmad/` → `~/.claude/circle/`
- `bmad-scope:` → `scope:` (all agent keys)
- `bmad-prioritize:` → `prioritize:`
- `bmad-arch:` → `arch:`
- `bmad-validate-prd:` → `validate-prd:`
- `bmad-security:` → `security:`
- `bmad-facilitate:` → `facilitate:`
- `bmad-impl:` → `impl:`
- `bmad-qa:` → `qa:`
- `bmad-ux:` → `ux:`
- Comments referencing `bmad-impl`, `bmad-tdd`, `bmad-qa` → remove prefix
- `bmad-code-review` → `code-review` in comments

**Step 5: Verify**

```bash
grep -i "bmad" plugin/resources/guardrails.md plugin/resources/deps-manifest.yaml plugin/resources/templates/config-example.yaml | grep -v "bmad-mcp" | grep -v "BMAD MCP"
# Expected: empty (except bmad-mcp references)
```

**Step 6: Commit**

```bash
git add plugin/resources/
git commit -m "refactor: update resources for Circle namespace"
```

---

### Task 6: Update Shell Scripts

Update install-deps.sh and update-deps.sh header comments and any BMAD references.

**Files:**
- Modify: `plugin/resources/scripts/install-deps.sh`
- Modify: `plugin/resources/scripts/update-deps.sh`

**Step 1: install-deps.sh**

Replace:
- `# BMAD — Dependency Installer` → `# Circle — Dependency Installer`
- `# First-time setup for BMAD ecosystem` → `# First-time setup for Circle ecosystem`
- Any `bmad` in comments → `circle` (but keep `bmad-mcp` package name as-is)

**Step 2: update-deps.sh**

Replace:
- `# BMAD — Dependency Update Script` → `# Circle — Dependency Update Script`
- `=== BMAD Dependencies Update ===` → `=== Circle Dependencies Update ===`
- `# bmad plugin (git pull if remote exists)` → `# circle plugin (git pull if remote exists)`
- Keep `bmad-mcp` package name references as-is

**Step 3: Verify**

```bash
grep -i "bmad" plugin/resources/scripts/*.sh | grep -v "bmad-mcp"
# Expected: empty
```

**Step 4: Commit**

```bash
git add plugin/resources/scripts/
git commit -m "refactor: update shell scripts for Circle namespace"
```

---

### Task 7: Update Templates

Update software templates that reference BMAD.

**Files:**
- Modify: `plugin/resources/templates/software/security-audit.md`
- Check: `plugin/resources/templates/software/PRD.md`
- Check: `plugin/resources/templates/software/architecture.md`
- Check: `plugin/resources/templates/docs/*.md`

**Step 1: Grep for BMAD references in templates**

```bash
grep -ri "bmad" plugin/resources/templates/
```

**Step 2: Replace any found references**

- `BMAD` → `Circle` in prose
- `/bmad:bmad-` → `/circle:` in command references

**Step 3: Commit (if changes found)**

```bash
git add plugin/resources/templates/
git commit -m "refactor: update templates for Circle namespace"
```

---

### Task 8: Update Documentation

Update README.md, GETTING-STARTED.md, CUSTOMIZATION.md, CHANGELOG.md.

**Files:**
- Modify: `README.md`
- Modify: `docs/GETTING-STARTED.md`
- Modify: `docs/CUSTOMIZATION.md`
- Modify: `docs/CHANGELOG.md`

**Step 1: README.md**

Major rewrite:
- Title: `# BMAD` → `# Circle`
- All `/bmad:bmad-<x>` → `/circle:<x>`
- All `bmad-<x>` in table command column → `<x>` (with `/circle:` prefix)
- `claude-plugin-bmad` → `claude-plugin-circle` (in setup paths)
- `~/.claude/bmad/` → `~/.claude/circle/`
- `plugin install bmad@bmad` → `plugin install circle@circle`
- Keep historical accuracy in any changelog references

**Step 2: GETTING-STARTED.md**

- All `/bmad:bmad-<x>` → `/circle:<x>`
- "BMAD" → "Circle" in prose
- `~/.claude/bmad/` → `~/.claude/circle/`

**Step 3: CUSTOMIZATION.md**

- All `/bmad:bmad-<x>` → `/circle:<x>`
- `bmad-<name>` in config examples → `<name>`
- `~/.claude/bmad/` → `~/.claude/circle/`
- `plugin/skills/bmad-<name>/` → `plugin/skills/<name>/`
- "BMAD" → "Circle" in prose

**Step 4: CHANGELOG.md**

- Add v1.0.0 entry at top:
  ```markdown
  ## v1.0.0 — Circle

  ### BMAD → Circle

  The plugin has been renamed from "BMAD" to "Circle" — aligning the name with holacracy's core concept. All commands change from `/bmad:bmad-*` to `/circle:*`.

  - **Plugin name**: `bmad` → `circle`
  - **Skill names**: `bmad-scope` → `scope`, `bmad-arch` → `arch`, etc. (prefix removed)
  - **Commands**: `/bmad:bmad-scope` → `/circle:scope`, etc.
  - **Output path**: `~/.claude/bmad/` → `~/.claude/circle/`
  - **Config keys**: `agents.bmad-scope` → `agents.scope`
  - **Repo**: `claude-plugin-bmad` → `claude-plugin-circle`

  ### Breaking Changes

  - All user commands changed
  - Output directory moved (no automatic migration)
  - Config keys changed (re-create config.yaml)
  - Run `/circle:init` after upgrading
  ```
- Keep all prior history entries intact (they reference BMAD historically)

**Step 5: Verify all docs**

```bash
grep -ri "bmad" README.md docs/ | grep -v "bmad-mcp" | grep -v CHANGELOG
# Expected: empty (CHANGELOG keeps historical references)
```

**Step 6: Commit**

```bash
git add README.md docs/
git commit -m "docs: update all documentation for Circle rename"
```

---

### Task 9: Update CLAUDE.md

Update project development instructions.

**Files:**
- Modify: `CLAUDE.md`

**Step 1: Replace references**

- `# BMAD Plugin` → `# Circle Plugin`
- `bmad-<lowercase>` naming convention → `<lowercase>` skill names
- `~/.claude/bmad/` → `~/.claude/circle/`
- `/bmad:bmad-<x>` → `/circle:<x>`
- `bmad-init`, `bmad-triage` etc. in exceptions → `init`, `triage`
- `plugin/skills/bmad-*/SKILL.md` → `plugin/skills/*/SKILL.md`
- `bmad-mcp` remains as-is (external package)

**Step 2: Verify**

```bash
grep -i "bmad" CLAUDE.md | grep -v "bmad-mcp"
# Expected: empty
```

**Step 3: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md for Circle namespace"
```

---

### Task 10: Final Verification Sweep

Full grep sweep to catch any remaining `bmad` references that should have been renamed.

**Step 1: Full sweep**

```bash
grep -ri "bmad" plugin/ README.md docs/ CLAUDE.md .claude-plugin/ | grep -v "bmad-mcp" | grep -v "BMAD MCP" | grep -v CHANGELOG | grep -v "plans/"
# Expected: empty
```

**Step 2: Verify skill discovery works**

```bash
ls plugin/skills/*/SKILL.md | wc -l
# Expected: 17
```

**Step 3: Verify frontmatter names match directory names**

```bash
for skill in plugin/skills/*/SKILL.md; do
  dir=$(basename $(dirname "$skill"))
  name=$(head -5 "$skill" | grep "^name:" | sed 's/name: //')
  if [ "$dir" != "$name" ]; then
    echo "MISMATCH: dir=$dir name=$name"
  fi
done
# Expected: no output (all match)
```

**Step 4: Verify no broken cross-references**

```bash
# Check that /circle: commands reference existing skills
grep -roh '/circle:[a-z-]*' plugin/ | sort -u | while read cmd; do
  skill="${cmd#/circle:}"
  if [ ! -d "plugin/skills/$skill" ] && [ ! -f "plugin/commands/$skill.md" ]; then
    echo "BROKEN: $cmd → no skill or command found"
  fi
done
# Expected: no output (all valid)
```

**Step 5: Final commit (if any fixes needed)**

```bash
# Only if step 1-4 found issues
git add -A
git commit -m "fix: resolve remaining stale references from rename"
```
