<!--
  verification-report.md — TEMPLATE (verifier-generated in practice).

  Written at the end of each loop run. Reports pass/fail per .feature scenario and,
  where a rubric exists, per criterion. For a pure-Validation feature, the
  Evaluation section is empty by design. Report specifics on any failure: which
  scenario/criterion, what was attempted, what's needed.

  Delete these comments once filled in.
-->

# verification-report.md — [feature-name]

**Feature:** [feature-name]
**Verification standard:** `[feature-name].feature` ([n] scenarios)[ + `[feature-name].rubric.md` ([m] criteria)]
**Evaluation set:** [N representative cases — only if there's a rubric]
**Result:** [✅ PASS | ❌ FAIL] — [summary, e.g. "Validation n/n, Evaluation m/m on iteration 2"]

---

## Validation layer — `.feature` scenarios

| Scenario | Iter 1 | Iter 2 |
|----------|:------:|:------:|
| [scenario title] | [✅/❌] | [✅/❌] |

## Evaluation layer — `.rubric.md` criteria

<!-- If the feature has no rubric, state that here and leave the table out. -->

| Criterion | Scale | Threshold | Iter 1 | Iter 2 |
|-----------|-------|-----------|:------:|:------:|
| [E1 name] | [0–5 / gate] | [≥ t / PASS] | [score] | [score] |

---

## Iteration notes

### Iteration [n] — [what failed, if anything]

**[❌ scenario or criterion]**
- **What was attempted:** [what the loop built]
- **Why it failed:** [the specific reason — which assertion, which threshold]
- **What was needed:** [the fix that closed it]

## Stop condition

[Both layers meet their standard → loop halts. OR: a stop condition was hit — say
which. Note whether a schema-change-proposal.md was needed.]
