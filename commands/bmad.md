# BMAD Corporate — Status Dashboard

Show the status of the BMAD framework for the current project.

## Process

1. **Detect project name**: `basename "$PWD" | tr '[:upper:]' '[:lower:]'`

2. **Detect domain** by analyzing files in the current directory:
   - **software**: if `Package.swift`, `*.xcodeproj`, `package.json`, `pom.xml`, `requirements.txt`, `go.mod`, `Cargo.toml` exists
   - **business**: if `business-plan.md`, `market-analysis.md`, `strategy.md` exists
   - **personal**: if `goals.md`, `journal.md`, or `habits/` folder exists
   - **general**: default if no indicator found

3. **Check workflow status**: Read `~/.claude/bmad/projects/<project-name>/output/session-state.json` if it exists.
   - If it exists: show current phase, active workflow, completed steps
   - If it doesn't exist: indicate BMAD is not yet initialized for this project

4. **Check existing artifacts**: List files in `~/.claude/bmad/projects/<project-name>/output/` if the directory exists. Show each agent's output files.

5. **Show formatted output**:

```
BMAD Corporate
==============
Project: <project-name>
Domain:  <detected>
Status:  <initialized/not initialized>
Phase:   <current phase from session-state or N/A>

Active workflow: <greenfield/sprint/none>
Completed steps: <list or N/A>

Generated artifacts:
  mary/      <list of files or empty>
  winston/   <list of files or empty>
  amelia/    <list of files or empty>
  murat/     <list of files or empty>
  sally/     <list of files or empty>
  john/      <list of files or empty>
  bob/       <list of files or empty>
  doris/     <list of files or empty>

Output directory: ~/.claude/bmad/projects/<project-name>/output/

Available agents:
  Team:
    /bmad-mary      - Mary, Business Analyst (requirements, user stories)
    /bmad-winston   - Winston, System Architect (design, ADRs, trade-offs)
    /bmad-amelia    - Amelia, Developer (implementation, code review)
    /bmad-murat     - Murat, Test Architect (test strategy, QA)
    /bmad-sally     - Sally, UX Expert (UI/UX design)
    /bmad-john      - John, Product Manager (prioritization, roadmap)
    /bmad-bob       - Bob, Scrum Master (sprint planning, coordination)
    /bmad-doris     - Doris, Documentation Specialist (doc generation)

  Orchestrators:
    /bmad-greenfield - Full workflow (analysis → QA, 6-9 steps)
    /bmad-sprint     - Sprint planning ceremony (6 steps)

  Utilities:
    /bmad-init       - Initialize BMAD for this project
    /bmad-shard      - Context sharding for large documents

Quick start: /bmad-init to initialize, then /bmad-mary to begin.
```
