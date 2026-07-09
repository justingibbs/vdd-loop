<!--
  [name].rubric.md — OPTIONAL DETAIL EXPANSION. Only create this file when an
  @eval criterion in [name].feature needs anchor descriptions, a judge protocol,
  or a multi-case evaluation set that can't fit in a line or two.

  If your @eval lines are self-contained (a simple gate or an obvious scale),
  you don't need this file. Most units don't.

  Reference from the .feature with:  # @eval-detail | [name].rubric.md

  The @eval lines in [name].feature are the source of truth for criteria, scales,
  and thresholds. This file only provides what didn't fit inline.

  Write against evaluation-guidelines.md. Strive to make each criterion ABLE TO FAIL.
  Delete these comments once filled in.
-->

# [name].rubric.md

*Optional Evaluation detail for [unit]. The `@eval` lines in `[name].feature` are
the source of truth for criteria, scales, and thresholds. This file provides what
didn't fit inline: anchor descriptions, judge protocol, and evaluation set.*

## What is being evaluated

[The specific output under judgment — e.g. "the summary text produced for a
dispute." Name the same output whose deterministic guardrails live in `[name].feature`.]

## Judge protocol

- **Judge:** [LLM-as-judge | human reviewer | LLM with human override]
- **Inputs to the judge:** source input + produced output. The judge does **not**
  see the threshold values from the `@eval` lines (avoid anchoring — score first,
  compare after).
- **Determinism note:** judgment scores vary run to run; design the pass condition
  for that.

## Criteria detail

<!-- One block per @eval criterion that needs anchor descriptions.
     The id here must match the id in the @eval line exactly. -->

### [E1 id] — [Name]

*Criterion defined in `@eval`: scale 0–5, threshold ≥[N]. Anchor descriptions:*

| Score | Meaning |
|-------|---------|
| 5 | [exemplary] |
| [threshold] | [just good enough] |
| ≤[threshold-1] | [not good enough — and why] |

*Could fail if:* [the evidence that would score it low]

### [E2 id] — [Name]  *(PASS/FAIL gate)*

*Criterion defined in `@eval`: PASS/FAIL, threshold PASS.*

- **PASS:** [what satisfies it]
- **FAIL:** [any single violation — a gate is not averaged]

*Why a gate:* [why one bad instance should block regardless of the rest]

## Evaluation set

[Description of the fixed set of representative cases to score over, when criteria
are scored over a set rather than a single case. Include happy path, hard cases,
adversarial cases.]
