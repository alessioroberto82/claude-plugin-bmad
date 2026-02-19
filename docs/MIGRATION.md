# Migration from BMAD-Setup to BMAD Plugin

This guide covers migrating from the original BMAD-Setup (global slash commands + shell script injection) to the BMAD plugin.

## What Changes

| Before (BMAD-Setup) | After (Plugin) |
|---|---|
| `~/.claude/commands/bmad.md` | Plugin skill: `/bmad:bmad-greenfield` |
| `~/.claude/commands/generate-docs.md` | Plugin skill: `/bmad:bmad-doris` |
| `~/.claude/commands/bmad-init.md` | Plugin skill: `/bmad:bmad-init` |
| `~/.claude/commands/bmad-remove.md` | Not needed (zero footprint by default) |
| `~/Documents/BMAD-Setup/soul.md` | `plugin/resources/soul.md` |
| `~/Documents/BMAD-Setup/bmad-section-template.md` | Distributed across 12 SKILL.md files |
| `~/Documents/BMAD-Setup/setup-bmad-in-project.sh` | Not needed (plugin auto-loads) |
| Single conversation role-playing | Real agent isolation (`context: fork`) |
| No state persistence | `session-state.json` with pause/resume |
| No quality gates | P0 blocks + QA reject gates |
| No token management | Context sharding via `/bmad:bmad-shard` |

## What Stays the Same

- Agent names: Mary, Winston, Amelia, Murat, Sally, John, Bob, Doris
- Output location: `~/.claude/bmad/projects/<project>/output/`
- Soul principles
- MCP integrations (Linear, Cupertino, claude-mem)
- Zero project footprint

## Migration Steps

### Step 1: Install the Plugin

```bash
# For development/testing
claude --plugin-dir /path/to/claude-plugin-bmad/plugin

# For permanent installation
claude plugin marketplace add /path/to/claude-plugin-bmad
claude plugin install bmad@bmad
```

### Step 2: Remove Old Slash Commands

```bash
rm ~/.claude/commands/bmad.md
rm ~/.claude/commands/bmad-init.md
rm ~/.claude/commands/bmad-remove.md
rm ~/.claude/commands/generate-docs.md
```

### Step 3: Remove BMAD Injection from Projects

For any project where you ran the old `/bmad-init`:

```bash
# In the project directory, remove BMAD markers from CLAUDE.md
cd /path/to/project
# The old bmad-remove command, or manually edit CLAUDE.md
# to remove content between <!-- BMAD-INJECT-START --> and <!-- BMAD-INJECT-END -->
```

### Step 4: Verify Existing Outputs

Your existing outputs in `~/.claude/bmad/projects/` are **fully compatible** — no changes needed. The plugin reads from and writes to the same location.

### Step 5: Create Per-Project Config (Optional)

If you had project-specific customizations embedded in the old `bmad-section-template.md`, move them to a per-project config:

```bash
# Copy the example config
cp /path/to/plugin/resources/templates/config-example.yaml \
   ~/.claude/bmad/projects/<project-name>/config.yaml

# Edit with your project-specific overrides
```

### Step 6: Archive BMAD-Setup

The old `~/Documents/BMAD-Setup/` directory is no longer needed. You can archive it:

```bash
mv ~/Documents/BMAD-Setup ~/Documents/BMAD-Setup-archived
```

## Command Mapping

| Old Command | New Command |
|---|---|
| `/bmad <task>` | `/bmad:bmad-greenfield` (full workflow) or invoke agents directly |
| `/bmad-init` | `/bmad:bmad-init` |
| `/bmad-remove` | Not needed |
| `/generate-docs` | `/bmad:bmad-doris` |
| N/A | `/bmad:bmad-mary` (standalone requirements) |
| N/A | `/bmad:bmad-winston` (standalone architecture) |
| N/A | `/bmad:bmad-sprint` (sprint ceremony) |
| N/A | `/bmad:bmad-shard` (context sharding) |
| N/A | `/bmad:bmad` (status dashboard) |

## Key Improvements After Migration

1. **Real isolation**: Each agent runs in its own context — no more "Winston remembers what Mary said" context pollution
2. **Pause/resume**: Stop mid-workflow, close your laptop, resume tomorrow
3. **Quality gates**: P0 security findings block implementation; QA rejects loop back
4. **Token efficiency**: Shard large documents, load only what's needed
5. **Team adoption**: `claude plugin install` — no more copying files and editing paths
6. **Extensibility**: Add an agent = create a directory with SKILL.md. Done.
