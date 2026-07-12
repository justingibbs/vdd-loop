---
name: vdd-bootstrap
description: Scaffold VDD into a project — copy in llm.txt and both guideline
  docs, instantiate SPEC.md / CLAUDE.md / AGENTS.md from the templates, and
  create the units/ structure — without clobbering anything that already exists.
  Run once per project, before the first Goal Storming session.
---

## Purpose

Make a project VDD-ready in one pass, so the next thing that happens is a Goal
Storming session, not file plumbing.

## Inputs

- the vdd-loop repo's `templates/**`, `llm.txt`, `gherkin-guidelines.md`,
  `evaluation-guidelines.md` — the source material.
- the target project root, and whatever already lives there (existing
  `CLAUDE.md` / `AGENTS.md` / `SPEC.md` / README, detectable tooling).

## Outputs

In the target project:

- `llm.txt`, `gherkin-guidelines.md`, `evaluation-guidelines.md` — copied in.
- `SPEC.md`, `CLAUDE.md`, `AGENTS.md` — instantiated from `templates/`, project
  name filled, tooling section populated with what step 3 detected, everything
  else left as bracketed placeholders.
- `units/` — created empty, or with one unit skeleton from
  `templates/units/[name]/` if the human already named the first unit of work.
- a closing summary of what was created, what was skipped, and what still says
  `[fill me in]`.

## Invariants

- **Never overwrite an existing file.** If `CLAUDE.md`, `AGENTS.md`, `SPEC.md`,
  or any file this skill would create already exists, do not replace it —
  propose the specific additions (the VDD method block, the SPEC protection
  rule, the `llm.txt` pointer) and let the human apply or approve them.
- **The SPEC protection rule must land** in the project's `CLAUDE.md` (or its
  equivalent context file). A bootstrap that skips it has failed.
- **`gherkin-guidelines.md` keeps its MIT license block** verbatim in the copy —
  the upstream copyright notice travels with the file.
- **Don't invent project content.** Placeholders stay placeholders; goals,
  constraints, and concepts come from Goal Storming, not from scaffolding.
- **Offer, don't advance.** Bootstrap ends by offering the first Goal Storming
  session; it never starts one itself.

## Procedure

1. **Survey the target.** List what already exists among the files to be
   created; note the project's detectable tooling (package manager, test
   framework, language) for step 3. Decide create vs. propose-additions per
   file, per the Invariants.
2. **Copy the contract set:** `llm.txt`, `gherkin-guidelines.md`,
   `evaluation-guidelines.md` into the project root.
3. **Instantiate the context files** from `templates/`: `SPEC.md`, `CLAUDE.md`
   (project name + detected tooling filled in; the rest bracketed), `AGENTS.md`
   as the thin pointer — inverting the pointer direction if the project's
   toolchain reads only `AGENTS.md`.
4. **Create `units/`.** If the human has already named the first unit of work,
   lay down `units/<name>/` from `templates/units/[name]/` (the `.goals`,
   `.feature`, and `.rubric.md` skeletons, renamed).
5. **Report and offer.** Summarize created/skipped/proposed and every remaining
   placeholder; offer `goal-storming-facilitator` for the first session.

## Composes with

- precedes ▶ `goal-storming-facilitator` — scaffold, then storm.
- everything downstream reads what this skill lays down.
