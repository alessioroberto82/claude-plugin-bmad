# Design: Security Guardian (`bmad-security`)

**Date**: 2026-02-24
**Status**: Approved
**Based on**: darthpelo/bmad-holacracy `bmad-security`, adapted to our conventions

## Overview

Add a Security Guardian role to the BMAD plugin, fully integrated into the greenfield workflow and code review pipeline. Two domains: software (STRIDE, OWASP Top 10) and business (GDPR, compliance, vendor risk). Single template with conditional sections.

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Domains | Software + Business (no personal) | Professional focus |
| Code review integration | Add Agent #6 Security Scan | Security in both pre-impl and PR review |
| Output directory | `output/security/` (dedicated) | Clean separation per role |
| Template strategy | Single template, conditional sections | Simpler to maintain |

## New Skill: `plugin/skills/bmad-security/SKILL.md`

- Holacracy role: Security Guardian
- Frontmatter: `context: fork`, `agent: qa`
- Soul reference, domain detection, config override (standard)
- Domain-agnostic core (no MCP tool names in body)

### Software Domain

- STRIDE threat model (Spoofing, Tampering, Repudiation, Info Disclosure, DoS, Elevation)
- OWASP Top 10 assessment
- Platform-specific security (detected from marker files)
- Vulnerability analysis with P0-P3 severity
- Remediation roadmap

### Business Domain

- Regulatory compliance (GDPR, CCPA, industry-specific)
- Data governance assessment
- Vendor risk analysis
- Data breach response evaluation
- Compliance gaps and remediation

### Security Gate

```
arch -> security (P0 check) -> impl
          |
          +-- P0 found -> SECURITY BLOCK -> fix -> re-run
          +-- P1 found -> PASS with warnings -> proceed
          +-- P2/P3    -> PASS -> proceed
```

### Handoff Messages

- SECURITY BLOCK: "P0 critical issues found. MUST fix before `/bmad-impl`."
- PASS with warnings: "P1 issues found. Proceed to `/bmad-impl`; fix P1 in parallel."
- PASS: "No blocking issues. Proceed to `/bmad-impl`."

## Files to Create

| File | Description |
|------|-------------|
| `plugin/skills/bmad-security/SKILL.md` | New Security Guardian skill |

## Files to Modify

| File | Change |
|------|--------|
| `plugin/skills/bmad-greenfield/SKILL.md` | Update Gate 1 to read from `output/security/`. Add `security` to mkdir. Update Role Sequence table |
| `plugin/skills/bmad-code-review/SKILL.md` | Add Agent #6 — Security Scan (OWASP in diff) |
| `plugin/skills/bmad-arch/SKILL.md` | Add security handoff suggestion |
| `plugin/resources/templates/software/security-audit.md` | Add conditional business sections (compliance, data governance) |
| `plugin/.claude-plugin/plugin.json` | Version bump to 0.5.0 |
| `CLAUDE.md` | Add bmad-security to structure, update skill count to 16, document conventions |

## Code Review Agent #6 — Security Scan

Scans the PR diff for:
- Injection patterns (SQL, command, XSS)
- Auth/authz issues (missing checks, hardcoded secrets)
- Crypto issues (weak algorithms, plaintext secrets)
- Data exposure (PII logging, verbose errors)

Same scoring (0-100) and threshold (80) as other agents.

## What Does NOT Change

- `bmad-qa` — unchanged, does not handle security
- `deps-manifest.yaml` — no new dependencies
- Zero project footprint — outputs to `~/.claude/bmad/`
- Domain-agnostic core — no domain-specific MCP tools in skill body
