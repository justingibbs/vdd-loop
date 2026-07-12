## gherkin-review — units/gherkin-review/fixtures/fixture-malformed-eval.feature

Verdict: **NEEDS WORK** (1 must-fix)

| Severity | Location | Guideline | Finding |
|----------|----------|-----------|---------|
| must-fix | @eval E1 | Inline evaluation: the @eval convention | The `@eval` line has four fields (`E1 \| Empathy \| 0-5 \| <description>`); the required `threshold` field is missing, so the verifier has no pass bar and the loop no stop signal for this criterion — fix: insert a threshold between scale and description, e.g. `# @eval \| E1 \| Empathy \| 0-5 \| ≥4 \| Draft acknowledges the customer's stated frustration before proposing a fix`. |
| consider | Feature block | Background | Both scenarios repeat the identical `Given an open ticket "TK-882"...` setup — fix: hoist the shared Given into a `Background`. |

Both scenarios themselves are observable and deterministic; the length-budget
scenario is a good objective floor under the judged Empathy criterion.

Next station: repair the `@eval` line and re-run this review, or walk through
the fix together — your call.
