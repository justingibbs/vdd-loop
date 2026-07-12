## gherkin-review — units/gherkin-review/fixtures/fixture-compound-scenario.feature

Verdict: **NEEDS WORK** (1 must-fix)

| Severity | Location | Guideline | Finding |
|----------|----------|-----------|---------|
| must-fix | Scenario: Updating the display name updates the profile and the audit log | Steps: language and semantics | The scenario contains two `When`→`Then` arcs — updating the display name, then exporting the audit log — which are two behaviors (the compound title, "...and the audit log", confirms it) — fix: split into `Scenario: Updating the display name updates the profile` and `Scenario: A display name change appears in the audit log`, each independently runnable with its own Given. |

No other findings; data is concrete and the language is declarative.

Next station: split the scenario and re-run this review, or walk through the
fix together — your call.
