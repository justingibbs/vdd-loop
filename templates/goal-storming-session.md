<!--
  goal-storming-session.md — TEMPLATE / WORKSHEET.

  Copy this per session and fill it in as you go. It's the runnable companion to
  docs/01-goal-storming.md (read that first for the full practice). Use it whether
  you're standing up a new PROJECT or scoping a single FEATURE.

  The room is humans + an LLM participant. Humans own the goals; the LLM proposes,
  challenges, and drafts, but does not ratify what matters.

  Delete these comments once you start.
-->

# Goal Storming — Session Worksheet

- **Scope:** [ ] Project  [ ] Feature of an existing project
- **Subject:** [project or feature name]
- **Date / participants:** [YYYY-MM-DD — names, + LLM]
- **Inherited constraints (feature sessions):** [point to the project SPEC.md]

---

## 0. Frame the scope

State plainly what you're storming and, for a feature, which project constraints it
inherits. This decides where the output lands (see *Where it goes*, bottom).

---

## 1. 🟩 Goals — "What does success mean here?"

*Outcomes, not tasks. If it presumes the solution ("add an endpoint"), it's below the
goal line. Don't move on until the humans agree these are right — this is the gate.*

- G1: [goal]
- G2: [goal]

---

## 2. Verifications — "What would prove we hit each goal?"

*This push is the heart of the session. Reach past the obvious; try even for the
fuzzy goals. A verification can be any form that credibly proves the goal — the two
common shapes are below, but invent one if neither fits. Attach each to a goal.*

*You are allowed to leave a goal without a verification — mark it as a **gap to
revisit**, don't let it stall the session. The failure is not trying, not the gap.*

### 🟨 Validations (deterministic → `.feature`)

| # | Goal | Validation |
|---|------|------------|
| V1 | G? | [deterministic, checkable outcome] |

### 🟦 Evaluations (judgment → `@eval` lines in `.feature`, only if needed)

| # | Goal | Evaluation | Scale / threshold |
|---|------|------------|-------------------|
| E1 | G? | [judgment-based quality] | [0–5 ≥ 4 / PASS-FAIL] |

### ⬜ Gaps to revisit

- [goal with no verification yet — and a note on why it's hard]

---

## 3. 🟥 Negative validations — "What must never happen?"

*Framed as prohibitions. Where security, safety, money, and data integrity live.
These join the YELLOW cards in the `.feature` file.*

- N1: [must never happen] (guards G?)

---

## 4. ⬛ Constraints — "What must any solution respect, regardless of approach?"

*Boundaries, not designs — "must use Postgres," not the schema. These become / update
`SPEC.md`.*

- C1: [constraint]

---

## 5. 🟪 Design Concept — "Can we say, in a breath, what this is?" *(optional)*

*Draft a few candidates (great place to let the LLM riff), then refine toward one
that's both succinct and enticing. If it won't come, that's a signal the goals aren't
settled — consider going back to section 1. Not required; when it comes, keep it.*

- Candidate: [one-breath framing]
- Candidate: [another]
- **Chosen:** [the one that fits]

---

## 6. Read the board back

Have someone (often the LLM) read it as one narrative: *"The goal is G; we'll know we
hit it when V and E; it must never N; within constraints C; and the whole thing is, in
a breath, [Design Concept]."* If the story doesn't hang together, you're not done.

## Exit checklist

- [ ] Every goal is agreed by the humans.
- [ ] Every goal was pushed on for a verification — and either carries one or is
      marked a known gap.
- [ ] Known prohibitions are on RED cards.
- [ ] Known constraints are on BLACK cards.
- [ ] A Design Concept exists, or the group consciously chose to proceed without one.

---

## Where it goes

| Cards | Destination |
|-------|-------------|
| 🟨 Validations + 🟥 Negatives | `units/<name>/<name>.feature` |
| 🟦 Evaluations | `# @eval` lines in `units/<name>/<name>.feature` (+ `<name>.rubric.md` if criteria need anchor descriptions) |
| ⬛ Constraints | `SPEC.md` |
| 🟩 Goals | `units/<name>/goals.md` (also at top of `SPEC.md` / `README.md` at project scale) |
| 🟪 Design Concept | top of `units/<name>/requirements.md` · or `SPEC.md` / `README.md` at project scale |
