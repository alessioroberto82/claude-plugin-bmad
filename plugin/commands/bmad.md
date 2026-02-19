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

5. **Show simple view** (default):

```
BMAD Corporate — <project-name>
================================
Domain:  <detected>
Status:  <initialized/not initialized>
Phase:   <current phase from session-state or "Not started">

What's done:
  <List completed steps, e.g. "Requirements (Mary)", "Architecture (Winston)">
  <Or "Nothing yet — run /bmad-init to get started">

What's next:
  <Next suggested step based on phase, e.g. "Talk to John about product planning">
  <Or "Run /bmad-greenfield for the full workflow">

Your team:
  /bmad-mary      — Mary, Business Analyst (requirements, user stories)
  /bmad-winston   — Winston, System Architect (design, trade-offs)
  /bmad-amelia    — Amelia, Developer (implementation, code review)
  /bmad-murat     — Murat, Test Architect (testing, quality)
  /bmad-sally     — Sally, UX Expert (UI/UX design)
  /bmad-john      — John, Product Manager (prioritization, roadmap)
  /bmad-bob       — Bob, Scrum Master (sprint planning)
  /bmad-doris     — Doris, Documentation Specialist

Workflows:
  /bmad-greenfield — Full workflow start to finish
  /bmad-sprint     — Sprint planning session

Review:
  /bmad-code-review — PR code review
  /bmad-triage      — Handle review feedback

Utilities:
  /bmad-init  — Set up BMAD for this project
  /bmad-shard — Split large docs for faster processing

Tip: Type /bmad detailed for version info and dependency status.
```

6. **If the user requests "detailed" or "full" view**, also show:

Generated artifacts:
```
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
```

Active workflow details:
```
Active workflow: <greenfield/sprint/none>
Completed steps: <list or N/A>
```

Check dependency versions: Read `~/.claude/plugins/installed_plugins.json` and check system binaries to show current versions.

```
Dependencies:
  Plugins:
    code-review     <version/hash>  (auto-update)
    feature-dev     <version/hash>  (auto-update)
    github          <version/hash>  (auto-update)
    swift-lsp       <version>
    swiftui-expert  <version>
    claude-mem      <version>
    Notion          <version>

  MCP Servers:
    bmad-mcp        <version from npm list -g bmad-mcp>
    cupertino       <version> (brew tap mihaelamj/tap)
    Linear          cloud (managed by Claude)

  Local:
    bmad-corporate  <version from plugin.json>

  Setup:  bash ~/Documents/claude-plugin-bmad-corporate/plugin/resources/scripts/install-deps.sh
  Update: bash ~/Documents/claude-plugin-bmad-corporate/plugin/resources/scripts/update-deps.sh
```
