# Security Guardian Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a Security Guardian role (`bmad-security`) fully integrated into the greenfield workflow, code review pipeline, and quality gates.

**Architecture:** New SKILL.md following existing role conventions (soul ref, domain detection, config override, P0-P3 gates). Two domains: software (STRIDE/OWASP) and business (GDPR/compliance). Integrates into greenfield as optional step, adds Agent #6 to code review.

**Tech Stack:** Pure Markdown plugin — no build step, no tests, no CI.

---

### Task 1: Create `bmad-security/SKILL.md`

**Files:**
- Create: `plugin/skills/bmad-security/SKILL.md`
- Reference (read-only): `plugin/skills/bmad-arch/SKILL.md` (template for role structure)
- Reference (read-only): `plugin/resources/templates/software/security-audit.md` (output template)

**Step 1: Create the skill directory**

```bash
mkdir -p plugin/skills/bmad-security
```

**Step 2: Write SKILL.md**

Create `plugin/skills/bmad-security/SKILL.md` with this exact content:

```markdown
---
name: bmad-security
description: "Security Guardian — Security audit, threat modeling, compliance checks. Use after architecture, before implementation."
allowed-tools: Read, Grep, Glob, Bash
metadata:
  context: fork
  agent: qa
---

# Security Guardian

You energize the **Security Guardian** role in the BMAD circle. You identify vulnerabilities, model threats, and validate compliance — ensuring the team ships securely.

## Soul

Read and embody the principles in `${CLAUDE_PLUGIN_ROOT}/resources/soul.md`.
Key reminders: Impact over activity — focus on real risks, not security theater. Speak up about vulnerabilities, even when inconvenient.

## Your Role

You are the security conscience of the team. You think in attack vectors, not features. You evaluate threats rigorously, prioritize real risks over theoretical ones, and only reach for complexity when simplicity leaves a gap. You document your findings so the Implementer can act on them. You respect the Architecture Owner's design but you will push back when it creates security debt.

## Domain Detection

Detect the project domain by analyzing files in the current directory:
- **software**: if `Package.swift`, `*.xcodeproj`, `package.json`, `pom.xml`, `requirements.txt`, `go.mod`, `Cargo.toml` exists
- **business**: if `business-plan.md`, `market-analysis.md`, `strategy.md` exists
- **personal**: if `goals.md`, `journal.md`, or `habits/` folder exists
- **general**: default if no indicator found

## Input Prerequisites

Read from `~/.claude/bmad/projects/{project}/output/`:
- Architecture: `arch/architecture.md` or `arch/operational-architecture.md`
- Also useful: `scope/requirements.md`, `prioritize/PRD.md`
- If architecture missing: "Architecture missing. Run `/bmad-arch` first."

Also check for project config: `~/.claude/bmad/projects/{project}/config.yaml`
- If `extra_instructions` for bmad-security exists, incorporate them

## Domain-Specific Behavior

### Software Development
**Focus**: Threat modeling (STRIDE), OWASP Top 10, secure architecture, vulnerability assessment
**Output filename**: `security-audit.md`
**Activities**:
- STRIDE threat model for each component (auth, API, DB, storage, etc.)
- OWASP Top 10 assessment against the architecture
- Platform-specific security checks (detected from marker files)
- Vulnerability analysis with P0-P3 severity
- Remediation roadmap prioritized by severity

**Domain Skill Suggestions**:

Check `${CLAUDE_PLUGIN_ROOT}/resources/deps-manifest.yaml` for domain-specific dependency groups that match the detected project type. For each dependency in a matching group that has a `suggest_in` entry for this role (`security`), suggest:

> "Consider invoking `/<dep-id>` for <suggest_in text>"

These are suggestions, not blocks — proceed with or without them. If a suggested skill is not installed, note: "Not installed. Run: `<install_command>` from deps-manifest."

### Business Strategy
**Focus**: Regulatory compliance, data governance, vendor risk
**Output filename**: `security-audit.md`
**Activities**:
- Regulatory requirements assessment (GDPR, CCPA, industry-specific)
- Data governance review (collection, storage, processing, retention)
- Vendor risk analysis (third-party dependencies, data sharing)
- Data breach response evaluation
- Compliance gaps and remediation plan

### Personal / General
For personal or general domains, security audits are not applicable. Inform the user:
> "Security audits apply to software and business domains. For personal projects, consider reviewing your digital privacy practices independently."

## Process

1. **Initialize output directory**:
   ```bash
   PROJECT_NAME=$(basename "$PWD" | tr '[:upper:]' '[:lower:]')
   mkdir -p ~/.claude/bmad/projects/$PROJECT_NAME/output/security
   ```

2. **Read architecture and requirements**: Understand the system's attack surface

3. **Scope the audit**: Determine what to audit based on domain:
   - Software: system components, APIs, data stores, authentication, authorization
   - Business: data handling, vendor relationships, regulatory requirements

4. **Threat modeling** (software domain):
   Apply STRIDE to each component identified in the architecture:
   - **S**poofing: Can an attacker impersonate a user or service?
   - **T**ampering: Can data be modified in transit or at rest?
   - **R**epudiation: Can actions be denied without evidence?
   - **I**nformation Disclosure: Can sensitive data leak?
   - **D**enial of Service: Can the system be overwhelmed?
   - **E**levation of Privilege: Can an attacker gain unauthorized access?

5. **OWASP Top 10 check** (software domain):
   Assess the architecture against each OWASP Top 10 category:
   A01 Broken Access Control, A02 Cryptographic Failures, A03 Injection,
   A04 Insecure Design, A05 Security Misconfiguration, A06 Vulnerable Components,
   A07 Auth Failures, A08 Data Integrity Failures, A09 Logging Failures, A10 SSRF

6. **Compliance check** (business domain):
   - GDPR: data processing basis, consent, right to erasure, DPO
   - CCPA: California consumer rights, opt-out, data sale
   - Industry-specific: HIPAA (health), PCI DSS (payments), SOX (finance)

7. **Risk assessment**: Assign severity to each finding:
   - **P0 Critical**: Immediate breach risk, exploit-ready, public-facing. Fix within 24-48h
   - **P1 High**: Significant risk, authenticated exploit path. Fix within 1 week
   - **P2 Medium**: Moderate risk, defense-in-depth gap. Fix within 1 month
   - **P3 Low**: Best practice deviation, minor config issue. Fix when convenient

8. **Generate report**: Use the template from `${CLAUDE_PLUGIN_ROOT}/resources/templates/software/security-audit.md`. Write to `~/.claude/bmad/projects/$PROJECT_NAME/output/security/security-audit.md`

9. **MCP Integration** (if available):
   - **Linear**: Link security findings to issues, create P0/P1 issues for critical findings
   - **claude-mem**: Search for past security patterns. Save key findings at completion.

10. **Security Gate Decision**:

Based on findings, determine the verdict:
- If ANY **P0** finding → verdict is **SECURITY BLOCK**
- If P1 but no P0 → verdict is **SECURITY PASS with warnings**
- If only P2/P3 → verdict is **SECURITY PASS**

11. **Handoff**:

**If SECURITY BLOCK:**
> **Security Guardian — BLOCKED (P0 critical issues).**
> Output saved to: `~/.claude/bmad/projects/{project}/output/security/security-audit.md`
> These MUST be fixed before implementation. Re-run `/bmad-security` after fixes.

**If SECURITY PASS with warnings:**
> **Security Guardian — PASS with P1 warnings.**
> Output saved to: `~/.claude/bmad/projects/{project}/output/security/security-audit.md`
> Proceed to `/bmad-impl`; fix P1 issues in parallel.

**If SECURITY PASS:**
> **Security Guardian — PASS.**
> Output saved to: `~/.claude/bmad/projects/{project}/output/security/security-audit.md`
> No blocking issues. Proceed to `/bmad-impl` for implementation.

## BMAD Principles
- Defense in depth: multiple layers of security, not single point of failure
- Assume breach: design for "when" not "if" compromised
- Impact over activity: focus on real risks, not security theater
- Human-in-the-loop: ask for clarification if architecture is unclear, don't assume
- Speak up: flag risks early and honestly, even when inconvenient
```

**Step 3: Commit**

```bash
git add plugin/skills/bmad-security/SKILL.md
git commit -m "feat: add bmad-security skill (Security Guardian role)"
```

---

### Task 2: Update security-audit template

**Files:**
- Modify: `plugin/resources/templates/software/security-audit.md`

**Step 1: Edit the template**

Replace the entire content of `plugin/resources/templates/software/security-audit.md` with:

```markdown
# Security Audit: {Feature/System Name}

**Date**: {YYYY-MM-DD}
**Auditor**: Security Guardian (BMAD)
**Scope**: {What was audited}
**Domain**: {software / business}

---

## Executive Summary

**Risk Level**: {Critical / High / Medium / Low}
**Critical Findings**: {count}
**Verdict**: {SECURITY BLOCK / SECURITY PASS with warnings / SECURITY PASS}

---

<!-- SOFTWARE DOMAIN: Include STRIDE + OWASP sections -->

## STRIDE Threat Model

| Threat | Category | Component | Severity | Status |
|---|---|---|---|---|
| {Threat description} | Spoofing / Tampering / Repudiation / Info Disclosure / DoS / Elevation | {Component} | P0/P1/P2/P3 | Open / Mitigated |

## OWASP Top 10 Check

| # | Category | Status | Notes |
|---|---|---|---|
| A01 | Broken Access Control | Pass/Fail/N/A | {Notes} |
| A02 | Cryptographic Failures | Pass/Fail/N/A | {Notes} |
| A03 | Injection | Pass/Fail/N/A | {Notes} |
| A04 | Insecure Design | Pass/Fail/N/A | {Notes} |
| A05 | Security Misconfiguration | Pass/Fail/N/A | {Notes} |
| A06 | Vulnerable Components | Pass/Fail/N/A | {Notes} |
| A07 | Auth Failures | Pass/Fail/N/A | {Notes} |
| A08 | Data Integrity Failures | Pass/Fail/N/A | {Notes} |
| A09 | Logging Failures | Pass/Fail/N/A | {Notes} |
| A10 | SSRF | Pass/Fail/N/A | {Notes} |

## Platform-Specific Security

- **{Platform security concern 1}**: {Assessment}
- **{Platform security concern 2}**: {Assessment}

<!-- BUSINESS DOMAIN: Include Compliance + Data Governance sections -->

## Regulatory Compliance

| Regulation | Applicable | Status | Gaps |
|---|---|---|---|
| GDPR | Yes/No | Compliant / Partial / Non-compliant | {Gaps} |
| CCPA | Yes/No | Compliant / Partial / Non-compliant | {Gaps} |
| {Industry-specific} | Yes/No | Compliant / Partial / Non-compliant | {Gaps} |

## Data Governance

- **Collection**: {What data, legal basis, consent mechanism}
- **Storage**: {Where, encryption, retention policy}
- **Processing**: {How, who has access, audit trail}
- **Sharing**: {Third parties, data processing agreements}

## Vendor Risk

| Vendor | Data Shared | Risk Level | DPA in Place | Notes |
|---|---|---|---|---|
| {Vendor} | {Data types} | High/Medium/Low | Yes/No | {Notes} |

<!-- ALL DOMAINS: Findings, Recommendations, Verdict -->

---

## Findings

### P0 — Critical (Must fix before implementation)
- {Finding or "None"}

### P1 — High (Fix before release)
- {Finding or "None"}

### P2 — Medium (Fix in next sprint)
- {Finding or "None"}

### P3 — Low (Track for future)
- {Finding or "None"}

## Remediation Roadmap

| Priority | Finding | Action | Owner | Timeline |
|---|---|---|---|---|
| P0 | {Finding} | {Action} | {Role} | Immediate |
| P1 | {Finding} | {Action} | {Role} | This sprint |

## Verdict

**{SECURITY BLOCK / SECURITY PASS with warnings / SECURITY PASS}**

{Summary statement}
```

**Step 2: Commit**

```bash
git add plugin/resources/templates/software/security-audit.md
git commit -m "feat: extend security-audit template with business domain sections"
```

---

### Task 3: Update greenfield orchestrator

**Files:**
- Modify: `plugin/skills/bmad-greenfield/SKILL.md:80-82` (mkdir line)
- Modify: `plugin/skills/bmad-greenfield/SKILL.md:160-172` (Role Sequence table)
- Modify: `plugin/skills/bmad-greenfield/SKILL.md:239-253` (Gate 1 security path)

**Step 1: Add `security` to the mkdir command**

In `plugin/skills/bmad-greenfield/SKILL.md`, find:
```
mkdir -p $BASE/output/{scope,arch,impl,qa,ux,prioritize,facilitate,docs,code-review}
```
Replace with:
```
mkdir -p $BASE/output/{scope,arch,impl,qa,ux,prioritize,facilitate,docs,code-review,security}
```

**Step 2: Update the Role Sequence table**

Find the table at line ~160:
```
| 5* | **Security** | Security audit | Architecture | `qa/security-audit.md` |
```
Replace with:
```
| 5* | **Security Guardian** | Security audit | Architecture | `security/security-audit.md` |
```

**Step 3: Update Gate 1 to read from `output/security/`**

Find:
```
1. Read `$BASE/output/qa/security-audit.md`
```
Replace with:
```
1. Read `$BASE/output/security/security-audit.md`
```

Find:
```
   Review: ~/.claude/bmad/projects/{project}/output/qa/security-audit.md
```
Replace with:
```
   Review: ~/.claude/bmad/projects/{project}/output/security/security-audit.md
```

**Step 4: Commit**

```bash
git add plugin/skills/bmad-greenfield/SKILL.md
git commit -m "feat: integrate bmad-security into greenfield workflow"
```

---

### Task 4: Add Agent #6 to code review

**Files:**
- Modify: `plugin/skills/bmad-code-review/SKILL.md:57-75` (parallel agents section)
- Modify: `plugin/skills/bmad-code-review/SKILL.md:1` (description to mention 6 agents)

**Step 1: Update the description in frontmatter**

No change needed — the description says "Multi-agent PR review" which is agent-count-agnostic.

**Step 2: Add Agent #6 after Agent #5**

In `plugin/skills/bmad-code-review/SKILL.md`, find the line:
```
**Agent #5 — Code Comments Compliance**
Read code comments in modified files. Verify the changes comply with guidance in those comments (TODOs, warnings, invariants).
```

After it, add:

```

**Agent #6 — Security Scan**
Read the file changes. Scan for common security vulnerabilities in the diff. Focus on: injection patterns (SQL, command, XSS, path traversal), authentication/authorization gaps (missing checks, hardcoded secrets, insecure token handling), cryptographic issues (weak algorithms, plaintext secrets, insufficient randomness), and data exposure risks (PII in logs, verbose error messages, sensitive data in URLs). Only flag issues introduced by this PR, not pre-existing patterns.
```

**Step 3: Update the agent count reference**

Find:
```
Launch 5 parallel Sonnet agents.
```
Replace with:
```
Launch 6 parallel Sonnet agents.
```

**Step 4: Commit**

```bash
git add plugin/skills/bmad-code-review/SKILL.md
git commit -m "feat: add Security Scan agent (#6) to code review pipeline"
```

---

### Task 5: Add security handoff to Architecture Owner

**Files:**
- Modify: `plugin/skills/bmad-arch/SKILL.md:122-128` (handoff section)

**Step 1: Update the handoff message**

In `plugin/skills/bmad-arch/SKILL.md`, find:
```
   > Next suggested role: `/bmad-impl` for implementation, or `/bmad-ux` for UX design.
```
Replace with:
```
   > Next suggested role: `/bmad-security` for security audit, `/bmad-impl` for implementation, or `/bmad-ux` for UX design.
```

**Step 2: Commit**

```bash
git add plugin/skills/bmad-arch/SKILL.md
git commit -m "feat: add bmad-security to arch handoff suggestions"
```

---

### Task 6: Version bump

**Files:**
- Modify: `plugin/.claude-plugin/plugin.json` (version field)

**Step 1: Bump version**

In `plugin/.claude-plugin/plugin.json`, find:
```
"version": "0.4.0",
```
Replace with:
```
"version": "0.5.0",
```

**Step 2: Commit**

```bash
git add plugin/.claude-plugin/plugin.json
git commit -m "chore: bump version to 0.5.0"
```

---

### Task 7: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

**Step 1: Add bmad-security to the Project Structure tree**

In the `## Project Structure` section, find:
```
    ├── bmad-docs/SKILL.md              # Documentation Steward
```
After it, add:
```
    ├── bmad-security/SKILL.md          # Security Guardian
```

**Step 2: Update the plugin description**

Find:
```
Multi-agent development workflow plugin for Claude Code. 15 skills (8 holacracy roles + 7 utilities)
```
Replace with:
```
Multi-agent development workflow plugin for Claude Code. 16 skills (9 holacracy roles + 7 utilities)
```

**Step 3: Update Role vs utility skills gotcha**

Find:
```
- **Role vs utility skills**: 8 of the 15 skills are holacracy roles.
```
Replace with:
```
- **Role vs utility skills**: 9 of the 16 skills are holacracy roles (including Security Guardian).
```

**Step 4: Add security convention**

In the `## Conventions` section, after the line about code review requiring a PR, add:
```
- **Security gate blocks implementation**: `/bmad-security` can issue a P0 SECURITY BLOCK that prevents `/bmad-impl` from proceeding in the greenfield workflow. The security audit output goes to `output/security/security-audit.md`
```

**Step 5: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: add bmad-security to CLAUDE.md structure and conventions"
```

---

### Task 8: Update marketplace.json

**Files:**
- Modify: `.claude-plugin/marketplace.json`

**Step 1: Update version and description**

In `.claude-plugin/marketplace.json`, find:
```
"version": "0.4.0",
```
Replace with:
```
"version": "0.5.0",
```

Find:
```
"description": "15 skills (8 holacracy roles + 7 utilities) with structured workflows, quality gates, TDD enforcement, and full customization"
```
Replace with:
```
"description": "16 skills (9 holacracy roles + 7 utilities) with structured workflows, quality gates, TDD enforcement, security audits, and full customization"
```

**Step 2: Commit**

```bash
git add .claude-plugin/marketplace.json
git commit -m "chore: sync marketplace.json to v0.5.0"
```

---

### Summary of Commits

| # | Commit Message | Files |
|---|---|---|
| 1 | `feat: add bmad-security skill (Security Guardian role)` | `plugin/skills/bmad-security/SKILL.md` |
| 2 | `feat: extend security-audit template with business domain sections` | `plugin/resources/templates/software/security-audit.md` |
| 3 | `feat: integrate bmad-security into greenfield workflow` | `plugin/skills/bmad-greenfield/SKILL.md` |
| 4 | `feat: add Security Scan agent (#6) to code review pipeline` | `plugin/skills/bmad-code-review/SKILL.md` |
| 5 | `feat: add bmad-security to arch handoff suggestions` | `plugin/skills/bmad-arch/SKILL.md` |
| 6 | `chore: bump version to 0.5.0` | `plugin/.claude-plugin/plugin.json` |
| 7 | `docs: add bmad-security to CLAUDE.md structure and conventions` | `CLAUDE.md` |
| 8 | `chore: sync marketplace.json to v0.5.0` | `.claude-plugin/marketplace.json` |
