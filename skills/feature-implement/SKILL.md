---
name: feature-implement
description: Run the VDD loop for one feature — derive requirements/plan/tasks from
  its verification standard, implement, verify (via verification-report), and loop
  until the standard passes or a bounded stop condition is hit. This is the core
  executable loop of VDD.
---

## Purpose

Turn a unit's verification standard into working, verified code. Given the
`@eval`-annotated `.feature` that a Goal Storming session produced, derive the
working docs, implement, verify, and loop — halting on PASS, or on a bounded
PAUSE / GIVE-UP so the loop can never spin forever. This skill *orchestrates the
loop*; it delegates the actual verdict to `verification-report`.

## Inputs

- `units/<name>/*.feature` — the complete verification standard: Validation scenarios
  and `@eval` Evaluation criteria. **Source of truth; read-only.** Scan all `.feature`
  files in the unit folder.
- `units/<name>/*.rubric.md` *(optional)* — Evaluation detail expansion: anchor
  descriptions for rich criteria. **Read-only.** Present only when pointed to by
  `@eval-detail` in a `.feature` file.
- `SPEC.md` — project constraints. **Protected; read-only** (see Invariants).
- `CLAUDE.md` — project conventions, tooling, and the BDD runner.

## Outputs

- `units/<name>/requirements.md` — the feature's requirements, with the GREEN
  goals listed at the top (the goals are the spine).
- `units/<name>/plan.md` — the architecture that satisfies the standard within
  `SPEC.md`'s constraints. Not a restatement of the scenarios.
- `units/<name>/tasks.md` — the atomic checklist derived from the plan.
- the implementation code.
- `units/<name>/verification-report.md` — written by `verification-report`,
  refreshed each iteration.
- `units/<name>/schema-change-proposal.md` — **only** if a SPEC change is needed
  (see Invariants).

## Invariants

- **`SPEC.md` is never edited directly.** If satisfying the standard requires
  changing a constraint in `SPEC.md`, invoke `spec-guardian`: write
  `units/<name>/schema-change-proposal.md` and **PAUSE for human review**. Do not
  proceed by editing `SPEC.md`.
- **Never weaken the standard to pass.** The `.feature` (including its `@eval` lines)
  is the fixed input. A `.rubric.md`, when present, is equally fixed. If the standard
  appears wrong or unsatisfiable, PAUSE and say so — do not edit it to go green.
- **Validation passes only via executed tests.** This is enforced by delegating the
  verdict to `verification-report`; never conclude a scenario passes by inspection.
- **`units/<name>/` is agent-owned.** Full freedom to write and rewrite the
  working docs there. The source-of-truth files above it are off-limits.

## Procedure

1. **Pre-flight.** Read the standard, `SPEC.md`, and `CLAUDE.md`. Optionally run
   `gherkin-review` (and `rubric-review`) on the standard; if it is malformed or
   internally contradictory, surface that before building anything.
2. **Derive the working docs.** Write `requirements.md` (GREEN goals atop) →
   `plan.md` → `tasks.md` in `units/<name>/`, all within `SPEC.md`'s constraints.
   Trace each requirement to the scenario(s)/`@eval` criteria it serves.
3. **Implement** the next unit of work per `tasks.md`. If the implementation cannot
   satisfy the standard without changing a `SPEC.md` constraint → invoke
   `spec-guardian` → **PAUSE** (see Invariants).
4. **Verify.** Call `verification-report`. It runs the `.feature` deterministically,
   scores the `@eval` criteria if present (loading `.rubric.md` anchor descriptions
   where linked), and writes/refreshes `verification-report.md`. Read back its
   verdict and the exact red set.
5. **Decide, based on the verdict:**
   - **All green** (Validation green; Evaluation meets thresholds and gates) → **PASS**. Stop.
   - **Red remaining, iteration < N, and the red set changed since last iteration**
     → progress is being made. Fix (return to step 3, or step 2 if the plan needs
     rework) and re-verify.
   - **Red set unchanged from the previous iteration** → the loop is stuck; this
     usually means a spec gap or missing information, not a fix away. **PAUSE** and
     report what's blocking.
   - **Iteration count reaches N** (default **3**) still red → **GIVE-UP**. Report
     the remaining failures for human triage.
6. **On any stop**, ensure `verification-report.md` reflects the final state and the
   reason for stopping.

## Stop conditions

- **PASS** — the Validation layer is green (via the runner) and the Evaluation layer
  meets every threshold with no failed gate.
- **PAUSE** — hand back to a human, with a written reason. Triggered by: a needed
  `SPEC.md` change (`schema-change-proposal.md` written via `spec-guardian`); the
  loop making no progress (red set unchanged across an iteration); or the standard
  itself appearing wrong.
- **GIVE-UP** — the iteration cap **N (default 3)** is reached with the standard
  still unmet. Report the remaining red items; do not keep looping.

*N is tunable per project (raise it for features expected to need more rounds), but
the loop is always bounded — an unbounded VDD loop is a bug.*

## Composes with

- calls ▶ `verification-report` — the verify step, every iteration.
- calls ▶ `spec-guardian` — when the work needs a change to `SPEC.md`.
- calls ▶ `gherkin-review` / `rubric-review` — optional pre-flight lint of the standard.
- consumes the standard produced by ◀ `goal-storming-facilitator`.
