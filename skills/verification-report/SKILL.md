---
name: verification-report
description: Check an implementation against its verification standard — run the
  .feature scenarios deterministically, score the .rubric.md by judgment, and write
  units/<name>/verification-report.md. Use standalone to re-verify, or as the
  verify step inside feature-implement.
---

## Purpose

Produce an honest verdict on whether an implementation meets its feature's
verification standard, and write that verdict to `verification-report.md`. This
skill *judges*; it does not build. It is the single place in VDD where "does it
pass?" is answered.

## Inputs

- `<unit>/*.feature` — the complete verification standard for a unit. Contains
  both the deterministic Validation scenarios **and** `# @eval` comment lines for
  any Evaluation criteria. **Read-only source of truth.** Scan all `.feature` files
  in the unit folder to collect both layers.
- `<unit>/*.rubric.md` *(optional)* — detail expansion for Evaluation criteria that
  need anchor descriptions, a judge protocol, or a multi-case evaluation set beyond
  what fits in an `@eval` line. Present only when pointed to by `# @eval-detail`.
  **Read-only.**
- the implementation code — what is being verified.
- `CLAUDE.md` — for the project's declared BDD runner and test tooling.

## Outputs

- `units/<name>/verification-report.md` — per-scenario Validation results
  (executed), per-criterion Evaluation results (scored, when a rubric exists), an
  overall verdict, and for every failure: what was attempted, why it failed, and
  what is needed. Follow the shape in `examples/*/specs/*/verification-report.md`.

## Invariants

- **Validation results come only from executed tests.** A scenario is green if and
  only if a real runner reports it green. Never mark a scenario passing by reading
  the code and judging it correct. Betraying determinism is the one thing this skill
  must not do.
- **Never edit the `.feature` or `.rubric.md` to make results pass.** They are the
  standard — including the `@eval` lines embedded in the `.feature`. If the standard
  itself looks wrong, say so in the report and stop — do not weaken it.
- **The judge is not shown the thresholds.** Give the Evaluation judge the source
  input, the output, and the criterion description (from the `@eval` line and, if
  present, the `.rubric.md` anchor descriptions) — but not the pass bars. Score
  first, compare after. This avoids anchoring.
- **Gates are not averaged.** A PASS/FAIL rubric gate that fails fails the layer,
  regardless of how high the scored criteria are.

## Procedure

1. **Read the standard.** Scan all `.feature` files in the unit folder. Parse every
   `# @eval` line to collect the Evaluation criteria (id, name, scale, threshold,
   description). If any `# @eval-detail` pointer exists, load that `.rubric.md` for
   the anchor descriptions and judge protocol it provides. Load the tooling section
   of `CLAUDE.md`.

2. **Validation — execute the `.feature` deterministically.**
   1. Identify the project's BDD runner from `CLAUDE.md` (e.g. Cucumber,
      pytest-bdd, behave, godog).
   2. **If no runner is configured, scaffold one** — pick the idiomatic BDD runner
      for the project's language, wire it up, and record the choice in the report.
      A missing runner is a setup task, not an excuse to skip execution.
   3. Generate or update the **step definitions** that bind each Gherkin step to the
      implementation. Keep them under the project's test tree, not in `specs/`.
   4. **Run the full `.feature`.** Record the real pass/fail for every scenario,
      including every RED (negative) scenario. Never self-certify a result.

3. **Evaluation — score the `@eval` criteria by judgment** *(skip entirely if no
   `@eval` lines exist across the unit's `.feature` files; note "no Evaluation
   layer" in the report).*
   1. Assemble the evaluation set — a fixed set of representative inputs, not a
      single case, where the criterion or its `.rubric.md` calls for a set.
   2. For each criterion, run the judge (LLM-as-judge, or a human reviewer who may
      override), showing it: the source input, the output, and the criterion
      description (plus `.rubric.md` anchor descriptions if a detail file exists)
      — **but not the threshold values**.
   3. Record each criterion's score or PASS/FAIL. Apply thresholds from the `@eval`
      lines exactly — scored criteria vs. their `≥N` threshold, PASS/FAIL gates
      applied un-averaged.

4. **Write `verification-report.md`.** Include: a per-scenario Validation table; a
   per-criterion Evaluation section (or the "none by design" note); the overall
   verdict; and for each failure, the *what was attempted / why it failed / what is
   needed* triad that lets the next loop iteration act on it. If a runner was
   scaffolded, note it. If iterating (called by `feature-implement`), show results
   per iteration as the examples do.

## Stop conditions

This skill runs once per call and emits a verdict; the *looping* is
`feature-implement`'s job. The verdict it writes is one of:

- **PASS** — every `.feature` scenario is green (via the runner) and, if `@eval`
  criteria exist, every criterion meets its threshold and no PASS/FAIL gate is FAIL.
- **FAIL** — one or more scenarios are red, or an `@eval` criterion is below its
  threshold, or a gate is FAIL. The report names exactly what is red and why.

## Composes with

- called by ◀ `feature-implement` — as its verify step, every loop iteration.
- runs standalone — to re-verify an existing implementation against its standard.
