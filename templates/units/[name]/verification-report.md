<!--
  verification-report.md — TEMPLATE (verifier-generated in practice).

  Written at the end of each loop run. Reports pass/fail per .feature scenario and,
  where @eval lines exist, per criterion. For a pure-Validation unit, the Evaluation
  section is empty by design. Report specifics on any failure.

  Delete these comments once filled in.
-->

# verification-report.md — [unit-name]

**Unit:** [unit-name]
**Verification standard:** `[name].feature` ([n] scenarios[ + [m] `@eval` criteria])
**Evaluation set:** [N representative cases — only if @eval criteria exist]
**Result:** [✅ PASS | ❌ FAIL] — [summary, e.g. "Validation n/n, Evaluation m/m on iteration 2"]

---

## Validation layer — `.feature` scenarios

| Scenario | Iter 1 | Iter 2 |
|----------|:------:|:------:|
| [scenario title] | [✅/❌] | [✅/❌] |

## Evaluation layer — `@eval` criteria

<!-- If the unit has no @eval lines, state "no Evaluation layer" and leave the
     table out. -->

| Criterion | Scale | Threshold | Iter 1 | Iter 2 |
|-----------|-------|-----------|:------:|:------:|
| [E1 name] | [0–5 / PASS/FAIL] | [≥ t / PASS] | [score] | [score] |

---

## Iteration notes

### Iteration [n] — [what failed, if anything]

**[❌ scenario or criterion]**
- **What was attempted:** [what the loop built]
- **Why it failed:** [the specific reason — which assertion, which threshold]
- **What was needed:** [the fix that closed it]

## Stop condition

[Both layers meet their standard → loop halts. OR: a stop condition was hit — say
which (PAUSE / GIVE-UP). Note whether a schema-change-proposal.md was needed.]
