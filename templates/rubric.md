<!--
  rubric.md — TEMPLATE. Copy to /evaluations/<feature-name>.rubric.md and fill in.

  This is the Evaluation layer: judgment-based criteria, scored rather than
  asserted. You only need a rubric when an outcome has no single correct answer
  (summarization, tone, relevance, classification quality). Most features need no
  rubric at all — if a deterministic check can settle it, put it in the .feature
  file instead.

  Write it against evaluation-guidelines.md. Remember: a verification is whatever
  credibly proves the goal — the scored-criterion shape below is the common
  pattern, not the only option. Strive to make each criterion ABLE TO FAIL.

  Delete these comments once filled in.
-->

# [feature-name].rubric.md

*Evaluation layer for [feature]. Judgment-based criteria from Goal Storming's BLUE
cards. Built from the toolkit in `evaluation-guidelines.md` — one way to prove this
feature's goal, not the required form.*

## What is being evaluated

[The specific output under judgment — e.g. "the summary text produced for a dispute."
Name the same output whose deterministic guardrails live in the `.feature` file.]

## Judge protocol

- **Judge:** [LLM-as-judge | human reviewer | LLM with human override]
- **Inputs to the judge:** [the source input + the produced output]. The judge does
  **not** see the threshold values below (avoid anchoring — score first, compare
  after).
- **Determinism note:** judgment scores vary run to run; the pass condition is
  designed for that (see below).

## Criteria

<!-- One block per criterion. Use 0–5 for graded qualities, PASS/FAIL for hard
     lines that must not be averaged away. Describe the threshold level and its
     neighbors — don't leave bare numbers. -->

### E1 — [Name]  *(scale: 0–5, threshold ≥ [t])*

[One sentence: what this criterion judges.]

| Score | Meaning |
|-------|---------|
| 5 | [exemplary] |
| [t] | [just good enough] |
| ≤[t-1] | [not good enough — and why] |

*Could fail if:* [the evidence that would score it low]

### E2 — [Name]  *(scale: PASS / FAIL)*

[One sentence: the hard line.]

- **PASS:** [what satisfies it]
- **FAIL:** [any single violation — a gate is not averaged]

*Why a gate:* [why one bad instance should block regardless of the rest]

## Aggregate pass condition

The Evaluation layer passes when **all** hold, scored over a fixed set of
representative cases (not a single example):

- [ ] E1 [Name] ≥ [t]  *(mean over the set)*
- [ ] E2 [Name] = PASS  *(every case — the gate is not averaged)*
- [ ] [additional criteria …]
