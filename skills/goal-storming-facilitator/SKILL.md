---
name: goal-storming-facilitator
description: Run a Goal Storming session per docs/01-goal-storming.md — either
  facilitating a live group or running solo structured Q&A with a single
  stakeholder — and emit the unit's standard files (.goals, .feature with @eval
  lines, proposed spec.md constraints). Humans ratify goals; the LLM proposes.
---

## Purpose

The front door of VDD: take a human (or a room of them) from "here's what I
want to build" to a ratified `.goals` file and, when the session goes deep
enough, a `.feature` verification standard — by asking, in order, what success
means and what would prove it.

## Inputs

- the session's **scope** (project or feature) and **mode** (live group /
  solo Q&A) — established in step 0.
- `docs/01-goal-storming.md` — the practice this skill executes.
- `templates/goal-storming-session.md` — the worksheet; `templates/units/[name]/`
  — the artifact skeletons.
- the project's `spec.md` / `SPEC.md` if one exists — inherited constraints.
  **Read-only.**
- `gherkin-guidelines.md` / `evaluation-guidelines.md` — for drafting the
  `.feature` and `@eval` lines well.

## Outputs

- `units/<name>/<name>.goals` — always: ratified goals, verification intent,
  known gaps, Design Concept if one came, unit-relevant constraints.
- `units/<name>/<name>.feature` — when the session hardens verifications that
  far (feature-scale sessions usually should; project-scale may stop at intent).
- ancillary verification files + their `@verify-detail` declarations — when a
  verification needs them (eval sets, fixtures).
- **proposed** `spec.md` constraint additions — as a proposal block or
  `schema-change-proposal.md`, never applied directly.
- optionally, the filled session worksheet.

## Invariants

- **Humans ratify goals. Always.** The LLM proposes, merges, splits, and
  challenges GREEN cards; it never declares them agreed. The session does not
  advance past step 1 without an explicit human yes — this is the family's one
  hard line, in both modes.
- **`spec.md` is never edited directly.** Constraints are emitted as proposals.
- **Push, don't block.** Every goal gets pushed for a verification; a goal with
  none is recorded as a *known gap to revisit*, never a stalled session.
- **Toolkit, not mandate.** A verification is whatever credibly proves the
  goal; the card colors are the common shapes, not the law. Strive for
  verifications that are *able to fail*.
- **Don't design.** BLACK cards capture boundaries, not schemas; if the room
  starts designing, name it and return to the boundary.

## Procedure

0. **Frame scope and mode.** Project or feature; inherited constraints named.
   Mode: **live** (multiple humans — the skill facilitates: sequences the
   cards, transcribes, challenges, keeps time) or **solo** (one stakeholder —
   the skill runs structured Q&A: it asks the card questions directly and
   proposes candidate cards for reaction). Both modes follow the same sequence.
1. **GREEN — surface the goals.** Ask *"what does success mean here?"* Propose
   goals the human hasn't voiced; merge duplicates, split compounds, flag tasks
   masquerading as goals. **Gate: humans ratify before proceeding.**
2. **YELLOW/BLUE — derive verifications, one goal at a time.** *"What,
   concretely, would prove this?"* Deterministic → YELLOW; judgment → BLUE
   (with scale and threshold); neither → invent the form and route it. Mark
   gaps and move on.
3. **RED — the guardrails.** *"What must never happen?"* — especially around
   security, money, and data. Each RED card asserts the *absence* of the
   forbidden effect.
4. **BLACK — the constraints.** *"What must any solution respect?"* Boundaries
   only. Route to the spec proposal.
5. **PURPLE — try the concept** *(optional)*. Riff candidates; if none lands,
   treat that as feedback on the goals, not a blank to force.
6. **Read the board back** as one narrative — goal, proofs, prohibitions,
   constraints, concept. If the story doesn't hang together, loop back.
7. **Write the artifacts** per Outputs, drafting the `.feature` against the
   guidelines. May call `gherkin-review` (and `rubric-review`) inline on the
   draft — reviewer findings come back to the room, not silently applied.
8. **Close by offering the next station:** `gherkin-review` if not yet run,
   then `derivability-review`, then the handoff (clean session builds per
   `llm.txt`). State what was produced; invoke nothing.

## Composes with

- may call ▶ `gherkin-review` / `rubric-review` — inline lint while drafting.
- feeds ▶ `derivability-review` — which probes the output and returns gaps
  here for revision.
- preceded by ◀ `vdd-bootstrap` — in a fresh project, scaffold first.
