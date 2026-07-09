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

1. Read the verification standard: the unit's `.feature` file(s) (Validation
   scenarios + `@eval` Evaluation criteria) and `SPEC.md` for constraints. If an
   `@eval-detail` pointer exists, load the linked `.rubric.md` for anchor descriptions.
2. Derive `requirements.md` → `plan.md` → `tasks.md` in `units/<name>/`.
3. Implement.
4. **Validate** deterministically against every `.feature` scenario.
5. **Evaluate** against `@eval` criteria where they exist (and `.rubric.md` anchors
   where linked).
6. Write `units/<name>/verification-report.md`.
7. Loop until both layers meet their standard, or a stop condition is hit.

The `.feature` file is the source of truth — it contains both the Validation
scenarios and the `@eval` Evaluation criteria. A `.rubric.md` may exist as optional
detail expansion for rich criteria; it is equally read-only. Everything else in
`units/<name>/` is agent-owned scaffolding — full freedom there.

## SPEC.md is protected

**Never edit `SPEC.md` without explicit human approval.** It is versioned and
protected. If a feature requires a change to `SPEC.md` (a new constraint, a data
model change, an ADR), do not edit it — write `units/<name>/schema-change-proposal.md`
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
- `units/<name>/` — one folder per unit of work (named like a branch: `password-reset`,
  `initial-build`). Contains everything for that unit:
  - `goals.md` — goals and verification intent.
  - `<name>.feature` — Validation scenarios + `@eval` Evaluation criteria (source of truth).
  - `<name>.rubric.md` — optional Evaluation detail (anchor descriptions, judge protocol).
  - `requirements.md`, `plan.md`, `tasks.md` — agent-generated working docs.
  - `verification-report.md` — verifier output, updated each loop iteration.
