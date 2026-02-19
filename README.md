# BMAD Corporate

A team of AI agents that helps you build software — from initial idea through to working code. Each agent has a name, a role, and a specialty. You talk to them in plain language, and they handle the rest.

Every agent on this team operates under the same set of principles — written by our founder Joris to capture the Luscii soul. Growth over ego. Iteration over perfection. Impact over activity. No gold-plating. No fear-driven engineering. These aren't slogans — they shape how every agent thinks, prioritizes, and communicates with you.

BMAD works for everyone on the team: product managers, designers, analysts, scrum masters, developers, and documentation writers. No programming knowledge required to get started.

**New to BMAD?** Start with the [Getting Started Guide](docs/GETTING-STARTED.md) — it walks you through your first conversation with no technical setup.

## The Team

| Command | Agent | Role |
|---|---|---|
| `/bmad-corporate:bmad-mary` | Mary | Business Analyst — gathers requirements, writes user stories, clarifies what you're building |
| `/bmad-corporate:bmad-winston` | Winston | System Architect — plans how software is structured, documents design decisions (ADRs) |
| `/bmad-corporate:bmad-amelia` | Amelia | Developer — writes code, reviews implementations |
| `/bmad-corporate:bmad-murat` | Murat | Test Architect — plans testing strategy, validates quality |
| `/bmad-corporate:bmad-sally` | Sally | UX Expert — designs user interfaces and user journeys |
| `/bmad-corporate:bmad-john` | John | Product Manager — prioritizes features, creates product plans (PRDs) |
| `/bmad-corporate:bmad-bob` | Bob | Scrum Master — plans sprints, coordinates the team |
| `/bmad-corporate:bmad-doris` | Doris | Documentation Specialist — generates docs from templates |

> **ADR** = Architecture Decision Record — a short document explaining why a technical decision was made.
> **PRD** = Product Requirements Document — describes what a product should do and why.

## Review

| Command | What it does |
|---|---|
| `/bmad-corporate:bmad-code-review` | Reviews a pull request using 5 parallel reviewers with confidence scoring, checking against your project's CLAUDE.md conventions |
| `/bmad-corporate:bmad-triage` | Triages incoming PR review comments — decides which to accept, reject, or clarify, then implements fixes |

## Orchestrators

These run multi-step workflows, guiding you through each phase with decision points along the way.

| Command | What it does |
|---|---|
| `/bmad-corporate:bmad-greenfield` | Runs the full workflow: Mary (requirements) → John (product plan) → Sally (design) → Winston (architecture) → Security review → Bob (sprint plan) → Amelia (code) → Murat (tests). You can skip optional steps. |
| `/bmad-corporate:bmad-sprint` | Interactive sprint planning ceremony — 6 steps from backlog review to sprint commitment |

## Utilities

| Command | What it does |
|---|---|
| `/bmad-corporate:bmad-init` | Sets up BMAD for your current project. Run this once per project. Checks for optional tools and offers to install them. |
| `/bmad-corporate:bmad-shard` | Splits large documents into smaller pieces (called "shards") so agents can work with just the part they need — reduces token usage by ~90% |
| `/bmad-corporate:bmad` | Shows project status: what phase you're in, what's been done, and what agents are available |

> **Token** = the unit of text that AI models process. Fewer tokens means faster responses and lower cost.
> **Context sharding** = breaking a large document into focused pieces so each agent loads only what it needs.

## Setup

```bash
# Load BMAD for the current session (development/testing)
claude --plugin-dir /path/to/claude-plugin-bmad-corporate/plugin

# Or install permanently via the marketplace
claude plugin marketplace add /path/to/claude-plugin-bmad-corporate
claude plugin install bmad-corporate@bmad-corporate
```

Then in any project:

```bash
/bmad-corporate:bmad-init          # Set up BMAD for this project
/bmad-corporate:bmad-mary          # Start by defining requirements
/bmad-corporate:bmad-greenfield    # Or run the full workflow
```

## Dependencies

All dependencies are **optional** — agents work without them and adapt when tools aren't available. `/bmad-init` detects what's installed and offers setup options.

| Dependency | Type | Group | What it adds |
|---|---|---|---|
| Linear | Cloud MCP | Core | Issue tracking and sprint management for all agents |
| claude-mem | Plugin | Core | Memory that persists across sessions for all agents |
| Cupertino | Brew MCP | iOS | Apple documentation and Human Interface Guidelines for iOS projects |
| SwiftUI Expert | Plugin | iOS | SwiftUI best practices and patterns |
| Swift LSP | Plugin | iOS | Code intelligence for Swift files |
| Notion | Plugin | Extras | Doris can publish docs to Notion |
| bmad-mcp | npm | Extras | Additional workflow tools for Greenfield orchestrator |

> **MCP** = Model Context Protocol — a way for Claude to connect to external services (like Linear or Apple docs). Think of it as a plugin for the plugin.

```bash
# First-time setup (interactive — walks you through what to install)
bash plugin/resources/scripts/install-deps.sh

# Check what's installed
bash plugin/resources/scripts/install-deps.sh --check-only

# Update everything
bash plugin/resources/scripts/update-deps.sh
```

The dependency manifest is at `plugin/resources/deps-manifest.yaml`. Per-project overrides go in `config.yaml` under the `dependencies:` key.

## Architecture

### Zero Footprint

BMAD never adds files to your project repository. All outputs are stored in a separate directory on your machine:

```
~/.claude/bmad/projects/<project>/
├── output/
│   ├── mary/          # Requirements
│   ├── winston/       # Architecture, ADRs
│   ├── amelia/        # Implementation notes
│   ├── code-review/   # PR review reports
│   ├── triage/        # Triage learnings
│   ├── murat/         # Test plans, reports
│   ├── sally/         # UX designs
│   ├── john/          # PRDs
│   ├── bob/           # Sprint plans
│   └── doris/         # Generated docs
├── shards/            # Context shards
│   ├── requirements/
│   ├── architecture/
│   └── stories/
└── config.yaml        # Per-project overrides
```

### Agent Isolation

Each work agent runs in its own isolated context — it starts fresh every time with no leftover state from previous runs. This prevents confusion between phases. Orchestrators and interactive workflows run in your main conversation so they can have multi-turn discussions with you.

### Quality Gates

Built-in safety checks prevent the workflow from advancing when something isn't right:

- **Security Block**: The greenfield orchestrator won't move to implementation if critical security issues are found
- **QA Reject Gate**: If Murat (testing) rejects the implementation, the workflow sends it back to Amelia (developer) for fixes
- **Completeness Check**: The orchestrator verifies output files exist before moving to the next step

### Context Sharding

Large documents (like a PRD or architecture spec) can be split into small, focused pieces called "shards":

```bash
/bmad-corporate:bmad-shard                    # Split documents into shards
/bmad-corporate:bmad-amelia STORY-001         # Implement one story at a time
```

Each invocation loads only the relevant shard (~300 tokens instead of ~5,000), making agents faster and cheaper to run.

### MCP Integration

Agents connect to external services through MCP (Model Context Protocol) when available. If a service isn't set up, agents simply skip those features — nothing breaks.

| MCP Server | Used By | What it provides |
|---|---|---|
| Linear | All agents | Issue tracking, sprint management |
| Cupertino | Winston, Amelia, Sally | Apple documentation, Human Interface Guidelines, Swift APIs |
| claude-mem | All agents | Memory that persists across Claude Code sessions |

## Customization

See [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md) for the full guide.

### Per-Project Config

Create `~/.claude/bmad/projects/<project>/config.yaml` to change how agents behave for a specific project:

```yaml
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

### Adding Agents

Drop a `SKILL.md` in `plugin/skills/bmad-<name>/`. Auto-discovered.

### Adding Templates

Drop a `.md` in `plugin/resources/templates/docs/` or `software/`.

## Workflows

### New Feature
```
Mary → John → [Sally] → Winston → [Security] → [Bob] → Amelia → Murat
```
Steps in brackets are optional.

### Bug Fix
```
Amelia (analyze) → Winston (review) → Amelia (fix) → Murat (verify)
```

### Code Review
```
Amelia (implement) → Murat (test) → Code Review (multi-agent PR review) → Triage (handle feedback) → merge
```

## Soul

The team principles live in `plugin/resources/soul.md` — every agent reads them on every invocation. To understand the culture behind BMAD, start there.

## Migration from BMAD-Setup

See [docs/MIGRATION.md](docs/MIGRATION.md).
