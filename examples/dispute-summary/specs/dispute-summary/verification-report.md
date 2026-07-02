# verification-report.md — dispute-summary

*Written by the verifier at the end of each loop run. Unlike a pure-Validation
feature, this report has **two populated layers**: deterministic `.feature`
scenarios and scored `.rubric.md` criteria. Both must pass for the feature to be
done.*

**Feature:** dispute-summary
**Verification standard:** `dispute-summary.feature` (4 scenarios) +
`dispute-summary.rubric.md` (4 criteria)
**Evaluation set:** 12 representative disputes
**Result:** ✅ PASS — Validation 4/4, Evaluation 4/4 on loop iteration 2

---

## Validation layer — `.feature` scenarios

| Scenario | Iter 1 | Iter 2 |
|----------|:------:|:------:|
| A summary is produced for a complete dispute | ✅ | ✅ |
| The summary stays within the length budget | ✅ | ✅ |
| The summary never leaks a full card number | ✅ | ✅ |
| No summary is produced from incomplete input | ✅ | ✅ |

Deterministic layer was green from iteration 1. The loop's work was entirely in
the Evaluation layer.

## Evaluation layer — `.rubric.md` criteria

Scored over the 12-dispute evaluation set. Thresholds from the rubric.

| Criterion | Scale | Threshold | Iter 1 | Iter 2 |
|-----------|-------|-----------|:------:|:------:|
| E1 Faithfulness | 0–5 mean | ≥ 4 | 4.5 ✅ | 4.6 ✅ |
| E2 Neutrality | PASS/FAIL gate | PASS (all) | **FAIL** ❌ | PASS ✅ |
| E3 Routing completeness | 0–5 mean | ≥ 4 | 3.6 ❌ | 4.3 ✅ |
| E4 Conciseness | 0–5 mean | ≥ 3 | 4.1 ✅ | 4.0 ✅ |

---

## Iteration 1 — two evaluation failures, looped back

**❌ E2 Neutrality — FAIL (gate)**

- **What happened:** on 2 of the 12 disputes, the summary editorialized —
  e.g. *"the customer was clearly overcharged"* — rendering a verdict the reviewer
  is meant to reach.
- **Why it failed:** neutrality is a **gate, not an average.** Even though 10/12
  summaries were neutral, two blame-assigning summaries fail the whole criterion by
  design (see rubric E2 rationale).
- **What was needed:** constrain the generation to attribute claims
  ("the customer states…", "the record shows…") and never assert fault. This is a
  prompt/instruction fix, not a code fix.

**❌ E3 Routing completeness — 3.6, below the ≥4 threshold**

- **What happened:** summaries frequently omitted the **transaction date**,
  scoring 3 ("one routing fact missing but inferable") across many cases.
- **Why it failed:** the mean fell below threshold because a routing fact was
  systematically dropped, not randomly.
- **What was needed:** require the four routing facts (what, amount, date, reason)
  explicitly in the generation step.

## Iteration 2 — both resolved

- Neutrality: claim attribution enforced; 0 blame-assigning summaries across the
  set → gate PASS.
- Completeness: the transaction date is now consistently included → mean 4.3.
- E1 and E4 held steady (the neutrality/completeness fixes didn't cost
  faithfulness or density).

All 4 scenarios and all 4 criteria meet their thresholds.

## What this example demonstrates

- **The Evaluation layer loops like the Validation layer does** — but the failure
  signal is a *score below threshold* or a *gate FAIL*, not a red assertion.
- **A gate criterion behaves differently from a scored one.** E2 failed on 2/12
  even with a 10/12 majority neutral; E3 failed on a sub-threshold *mean*. The
  report has to surface both failure shapes.
- **Deterministic and judgment checks are complementary.** The `.feature` length
  cap passed the whole time; conciseness (E4) is a different, softer question that
  the rubric — not the feature file — is responsible for.

## Stop condition

Both layers meet their standard. The loop halts. No `schema-change-proposal.md`
was needed.
