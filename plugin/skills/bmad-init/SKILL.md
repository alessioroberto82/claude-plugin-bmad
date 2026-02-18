---
name: bmad-init
description: Initialize BMAD framework for the current project. Creates output directories in home folder (zero project footprint). Run once per project.
context: same
---

# BMAD Init

Initialize the BMAD-METHOD framework for the current project. All outputs are stored externally in the home directory — nothing is added to the project repository.

## Process

1. **Detect project name**:
   - Derive from current directory: `basename "$PWD" | tr '[:upper:]' '[:lower:]'`

2. **Detect domain** by analyzing files in the current directory:
   - **software**: if `Package.swift`, `*.xcodeproj`, `package.json`, `pom.xml`, `requirements.txt`, `go.mod`, `Cargo.toml` exists
   - **business**: if `business-plan.md`, `market-analysis.md`, `strategy.md` exists
   - **personal**: if `goals.md`, `journal.md`, or `habits/` folder exists
   - **general**: default if no indicator found

3. **Create output structure** (zero footprint — all in home directory):
   ```bash
   PROJECT_NAME=$(basename "$PWD" | tr '[:upper:]' '[:lower:]')
   BASE=~/.claude/bmad/projects/$PROJECT_NAME

   mkdir -p $BASE/output/{mary,winston,amelia,murat,sally,john,bob,doris,code-review}
   mkdir -p $BASE/shards/{requirements,architecture,stories}
   mkdir -p $BASE/workspace
   ```

4. **Create session state**:
   Write to `~/.claude/bmad/projects/$PROJECT_NAME/output/session-state.json`:
   ```json
   {
     "project": "<project-name>",
     "domain": "<detected-domain>",
     "phase": "analysis",
     "created": "<ISO-8601 timestamp>",
     "updated": "<ISO-8601 timestamp>",
     "artifacts": [],
     "workflow": {
       "type": "none",
       "current_step": null,
       "completed_steps": [],
       "checkpoints": []
     }
   }
   ```

5. **Check for project config**:
   - If `~/.claude/bmad/projects/$PROJECT_NAME/config.yaml` exists, report it
   - If not, suggest: "Create `~/.claude/bmad/projects/$PROJECT_NAME/config.yaml` for project-specific customization."

6. **Confirm**:
   ```
   BMAD initialized for: <project-name>
   Domain: <detected-domain>
   Output: ~/.claude/bmad/projects/<project-name>/output/

   Available agents:
     /bmad-mary      - Business Analyst (requirements, user stories)
     /bmad-winston   - System Architect (design, ADRs, trade-offs)
     /bmad-amelia    - Developer (implementation, code review)
     /bmad-murat     - Test Architect (test strategy, QA)
     /bmad-sally     - UX Expert (UI/UX design)
     /bmad-john      - Product Manager (prioritization, roadmap)
     /bmad-bob       - Scrum Master (sprint planning, coordination)
     /bmad-doris     - Documentation Specialist (doc generation)

   Review:
     /bmad-code-review - Multi-agent PR code review with CLAUDE.md compliance

   Orchestrators:
     /bmad-greenfield - Full workflow (analysis → QA)
     /bmad-sprint     - Sprint planning ceremony

   Start with: /bmad-mary to gather requirements, or /bmad-greenfield for the full workflow.
   ```
