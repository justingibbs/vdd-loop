# requirements.md — dispute-summary

> *A neutral one-breath brief that lets a reviewer route a dispute without
> opening the case file.*
> — Design Concept (🟪 PURPLE), from the Goal Storming session for this unit.

*Agent-generated interpretation of `dispute-summary.feature` (Validation scenarios
and `@eval` Evaluation criteria), with anchor detail from `dispute-summary.rubric.md`.
This unit spans both verification layers, so requirements trace to a `.feature`
scenario, an `@eval` criterion, or both.*

*This example keeps its working docs intentionally light — a requirements file and
a verification report, no separate `plan.md`/`tasks.md`. Per VDD design decision
#4, the agent has full freedom here and includes only what's useful; a
summarization feature this contained didn't warrant a separate architecture doc.*

---

## Goal (🟩 GREEN)

A dispute reviewer can grasp what a dispute is about, and decide how to route it,
**without opening the full case file.**

## Two layers, one goal

The goal has a deterministic face and a judgment face, so it needs both layers:

- **Validation** (deterministic): the summary exists, references the case, stays
  within a length budget, leaks no PII, and fails closed on incomplete input.
- **Evaluation** (judgment): the summary is faithful, neutral, complete enough to
  route on, and concise. These can't be asserted — they're scored via `@eval`.

Neither layer alone proves the goal. A summary can pass every `.feature` scenario
(right length, right id, no PII) and still be useless if it's unfaithful or takes
a side — which is exactly what the `@eval` criteria guard.

## Requirements

| # | Requirement | Verified by |
|---|-------------|-------------|
| R1 | A summary is produced for a complete dispute and references the case id. | `.feature`: *A summary is produced…* |
| R2 | The summary stays within the 150-word budget. | `.feature`: *…within the length budget* |
| R3 | The summary never exposes a full PAN; card references are masked to last 4. | `.feature`: *…never leaks a full card number* |
| R4 | Incomplete input yields no summary and names the missing input. | `.feature`: *No summary…from incomplete input* |
| R5 | The summary represents only facts present in the source. | `@eval` **E1** (Faithfulness ≥ 4) |
| R6 | The summary assigns no blame and attributes claims. | `@eval` **E2** (Neutrality = PASS) |
| R7 | The summary carries the routing facts: what, amount, date, reason. | `@eval` **E3** (Routing completeness ≥ 4) |
| R8 | The summary is dense, not merely under the word cap. | `@eval` **E4** (Conciseness ≥ 3) |

## Constraints inherited from SPEC.md (⬛ BLACK)

- PII handling: full PANs must never appear in generated text (also enforced
  deterministically by R3 — belt and suspenders across both layers).
- The summary is decision-support only; it must not state a resolution or verdict
  (the source of the E2 neutrality gate).

## Non-goals

- Deciding the dispute. The feature summarizes; it never rules.
- Translating or normalizing the source record — it summarizes what's there.
