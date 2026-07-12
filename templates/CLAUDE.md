<!--
  CLAUDE.md — TEMPLATE. Copy into your project root and fill in.

  This is the "how we work" file: always-active context the agent reads every
  session. It changes rarely. Keep it short and durable — tooling rules,
  the VDD contract pointer, the SPEC.md protection rule.

  Delete these comments once filled in.
-->

# CLAUDE.md — [Project Name]

How we work in this repo. Always-active context — read this every session before
touching code or verification artifacts.

## The method: VDD

This project uses **Verification-Driven Development**. Read **`llm.txt`** (copied
from the vdd-loop repo) for the full contract; the short version:

- Work is defined by verification standards, not specs. Each unit of work has a
  folder holding `<name>.goals` (why) and `<name>.feature` (the standard:
  Validation scenarios + `@eval` Evaluation criteria). The `.feature` is the
  source of truth and tells you when you're done.
- **Building:** read the unit's `.feature` + `.goals` + `SPEC.md` and any linked
  verification files, then build however you judge best. Your working docs
  (plans, task lists, notes, reports) are your own — keep them in the unit
  folder.
- **Verifying:** validations pass only via executed checks (real runner, real
  assertions — never by inspection). `@eval` criteria are scored by a judge that
  doesn't see the thresholds. Loop until the standard passes, with a bounded
  iteration cap; if the same failures survive an iteration unchanged, stop and
  report.
- **Never weaken the standard to pass.** `.feature`, `.goals`, and ancillary
  verification files are read-only. If the standard looks wrong, say so.

## SPEC.md is protected

**Never edit `SPEC.md` without explicit human approval.** If satisfying a
standard requires changing a constraint, write
`units/<name>/schema-change-proposal.md` and **pause for human review**.

## Authoring verifications

When drafting or reviewing standards (with a human, via Goal Storming):

- **Validation (`.feature` scenarios):** follow `gherkin-guidelines.md`.
- **Evaluation (`@eval` lines, `.rubric.md` detail):** follow `evaluation-guidelines.md`.
- Humans ratify goals; you propose and challenge.

## Tooling and conventions

- **Language / runtime:** [e.g. TypeScript on Node 20]
- **Package manager:** [e.g. pnpm — do not use npm/yarn]
- **Test framework:** [e.g. Vitest] · **BDD runner:** [e.g. Cucumber for `.feature`]
- **Lint / format:** [e.g. Biome — run before every commit]
- **Naming conventions:** [files, symbols, branches]
- **Commit / PR conventions:** [message format, branch naming, review rules]
- **Anything the agent must never do:** [e.g. no new dependencies without approval]

## Where things live

- `SPEC.md` — project constraints; may read like a traditional spec, but the
  constraints section is what binds the agent. Versioned & protected.
- `units/<name>/` — one folder per unit of work, named like a git branch
  (`password-reset`, `initial-build`). A project build-out may hold feature
  subfolders. Contains:
  - `<name>.goals` — Goal Storming output: goals, verification intent, concept.
  - `<name>.feature` — the verification standard (source of truth).
  - `<name>.rubric.md` *(optional)* — Evaluation detail, linked via `@eval-detail`.
  - whatever working docs the building agent generates — its own business.
