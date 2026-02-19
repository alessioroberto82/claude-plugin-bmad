# Getting Started with BMAD

BMAD is a team of AI agents that help you build software — from initial idea through to working code. Each agent has a name, a role, and a specialty, just like a real team.

You talk to them using simple commands in Claude Code. No programming knowledge required.

## Who is this for?

BMAD is designed for everyone involved in building a product:

- **Product Managers** — define what to build, prioritize features, create roadmaps
- **Business Analysts** — gather requirements, write user stories, clarify scope
- **Designers** — create UI/UX designs, map user journeys, build wireframes
- **Scrum Masters** — plan sprints, coordinate the team, track progress
- **Developers** — implement features, review code, run tests
- **Documentation writers** — generate docs from templates, keep things consistent

You don't need to be technical to use BMAD. If you can type a sentence and press Enter, you can work with the team.

## Meet the team

| Name | Role | What they do |
|------|------|-------------|
| **Mary** | Business Analyst | Helps you define what you're building and why |
| **John** | Product Manager | Prioritizes features and creates a product plan |
| **Sally** | UX Expert | Designs the user experience and interface |
| **Winston** | System Architect | Plans how the software will be structured |
| **Amelia** | Developer | Writes and reviews the actual code |
| **Murat** | Test Architect | Makes sure everything works correctly |
| **Bob** | Scrum Master | Organizes the work into sprints |
| **Doris** | Documentation Specialist | Creates project documentation |

## Your first conversation

The easiest way to start is by talking to **Mary**. She'll ask you questions about what you want to build and help you think through the details.

1. Open Claude Code
2. Type this and press Enter:

```
/bmad:bmad-mary
```

3. Mary will ask you about your project. Just answer in plain language — describe what you want to build, who it's for, and what problem it solves.

4. When she's done, she'll save a requirements document and suggest which agent to talk to next.

That's it. Each agent works the same way: type the command, have a conversation, get results.

## Quick paths by role

### If you're a Product Manager

Start with Mary to gather requirements, then talk to John to create a product requirements document (PRD) and prioritize features:

```
/bmad:bmad-mary
```
then
```
/bmad:bmad-john
```

### If you're a Designer

After requirements are gathered, talk to Sally about the user experience:

```
/bmad:bmad-sally
```

### If you're a Scrum Master

Use Bob to run sprint planning, or use the sprint ceremony workflow:

```
/bmad:bmad-bob
```
or
```
/bmad:bmad-sprint
```

### If you're a Developer

After the architecture is designed, talk to Amelia to start implementing:

```
/bmad:bmad-amelia
```

### If you want the full workflow

The greenfield command runs the entire process from start to finish, with you making decisions at each step:

```
/bmad:bmad-greenfield
```

This walks through: Mary (requirements) → John (product plan) → Sally (design) → Winston (architecture) → Bob (sprint planning) → Amelia (implementation) → Murat (testing). You can skip steps that don't apply.

## Available commands

Every command starts with `/bmad:`. Just type it and press Enter.

| Command | What it does |
|---------|-------------|
| `/bmad:bmad-mary` | Talk to Mary about requirements |
| `/bmad:bmad-john` | Talk to John about product planning |
| `/bmad:bmad-sally` | Talk to Sally about design |
| `/bmad:bmad-winston` | Talk to Winston about architecture |
| `/bmad:bmad-amelia` | Talk to Amelia about implementation |
| `/bmad:bmad-murat` | Talk to Murat about testing |
| `/bmad:bmad-bob` | Talk to Bob about sprint planning |
| `/bmad:bmad-doris` | Talk to Doris about documentation |
| `/bmad:bmad-greenfield` | Run the full workflow start to finish |
| `/bmad:bmad-sprint` | Run a sprint planning session |
| `/bmad:bmad-code-review` | Review a pull request |
| `/bmad:bmad-triage` | Handle review feedback on a pull request |
| `/bmad:bmad-shard` | Split large documents into smaller pieces (saves time and cost) |
| `/bmad:bmad-init` | Set up BMAD for your current project (run once) |
| `/bmad:bmad` | See project status and what's been done |

## Where does everything go?

BMAD keeps all its work in a folder on your computer, completely separate from your project files. Nothing gets added to your codebase unless you explicitly ask a developer agent to write code.

All outputs are saved to: `~/.claude/bmad/projects/<your-project>/output/`

Each agent saves their work in their own subfolder (e.g., `mary/`, `winston/`, `amelia/`).

## Tips

- **You can talk to any agent at any time.** There's no strict order — use whoever makes sense for what you need right now.
- **Agents remember context within a session.** If Mary creates requirements, John can read them when you ask him to create a product plan.
- **You can customize how agents behave** per project. See the [Customization Guide](CUSTOMIZATION.md) for details.
- **All dependencies are optional.** BMAD works out of the box. Extra integrations (like Linear for issue tracking) add functionality but aren't required.

## Next steps

- Run `/bmad:bmad-init` to set up BMAD for your project
- Start with `/bmad:bmad-mary` to define what you're building
- Check status anytime with `/bmad:bmad`
- Read the [Customization Guide](CUSTOMIZATION.md) when you want to tailor the workflow
