<!--
  CLAUDE.md — TEMPLATE. Copy into your project root and fill in.

  This is the "how we work" file: always-active context the agent reads every
  session. It changes rarely. Keep it short and durable — tooling rules,
  conventions, the SPEC protection rule, and pointers to the verification guides.

  (AGENTS.md sits beside this file as a thin pointer to it, so tools that look for
  either name find the same guidance. Keep the content HERE; don't fork it.)

  Delete these comments once filled in.
-->

# CLAUDE.md — [Project Name]

How we work in this repo. Always-active context — read this every session before
touching code or verification artifacts.

## The method: VDD

This project uses **Verification-Driven Development**. The short version of the loop:

1. Read the verification standard for the feature: its `.feature` file (Validation)
   and, if present, its `.rubric.md` (Evaluation), plus `SPEC.md` for constraints.
2. Derive `requirements.md` → `plan.md` → `tasks.md` under `specs/<feature>/`.
3. Implement.
4. **Validate** deterministically against every `.feature` scenario.
5. **Evaluate** against `.rubric.md` criteria where one exists.
6. Write `specs/<feature>/verification-report.md`.
7. Loop until both layers meet their standard, or a stop condition is hit.

The `.feature` and `.rubric.md` files are the source of truth. Everything under
`specs/<feature>/` is agent-owned scaffolding — you have full freedom there.

## SPEC.md is protected

**Never edit `SPEC.md` without explicit human approval.** It is versioned and
protected. If a feature requires a change to `SPEC.md` (a new constraint, a data
model change, an ADR), do not edit it — write `specs/<feature>/schema-change-proposal.md`
describing the needed change and **pause for human review.**

## Verification guides

Write and review verification artifacts against these:

- **Validation (`.feature` files):** follow `gherkin-guidelines.md`.
- **Evaluation (`.rubric.md` files):** follow `evaluation-guidelines.md`.

A verification is whatever credibly proves a goal — the guides document the common
patterns and leave room to invent. Strive to make every verification *able to fail*.

## Tooling and conventions

<!-- Fill in your project's specifics. These are the rules the agent must not guess. -->

- **Language / runtime:** [e.g. TypeScript on Node 20]
- **Package manager:** [e.g. pnpm — do not use npm/yarn]
- **Test framework:** [e.g. Vitest] · **BDD runner:** [e.g. Cucumber for `.feature`]
- **Lint / format:** [e.g. Biome — run before every commit]
- **Naming conventions:** [files, symbols, branches]
- **Commit / PR conventions:** [message format, branch naming, review rules]
- **Anything the agent must never do:** [e.g. no new dependencies without approval]

## Where things live

- `SPEC.md` — project constraints, architecture, versioned & protected.
- `/features/*.feature` — the Validation layer, one file per user story.
- `/evaluations/*.rubric.md` — the Evaluation layer (only where judgment is needed).
- `/specs/<feature>/` — agent-generated working docs and the verification report.
