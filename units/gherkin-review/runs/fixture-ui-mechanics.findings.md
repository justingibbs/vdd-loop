## gherkin-review — units/gherkin-review/fixtures/fixture-ui-mechanics.feature

Verdict: **PASS** (no must-fix findings — 1 should-fix, 1 consider)

| Severity | Location | Guideline | Finding |
|----------|----------|-----------|---------|
| should-fix | Scenario: A visitor subscribes with a valid address | Scenarios | The `When` step is imperative UI mechanics — selectors (`#newsletter-input`, `#subscribe-btn`) and click/type actions instead of domain behavior — fix: state the behavior, e.g. `When the visitor subscribes with "sam@example.com"`; leave selectors to the step definitions. |
| consider | Scenario: A visitor subscribes with a valid address | Steps: language and semantics | The same `When` bundles three actions (click, type, click) in one step — fix: after rewriting declaratively this collapses to one action; if mechanics must stay, split to one action per step. |

The second scenario (a confirmed subscriber receives the next newsletter) is
declarative and observable.

Next station: rewrite the `When` declaratively and re-run this review, or
hand off to the coding agent if you accept the standard as-is — your call.
