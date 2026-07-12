## gherkin-review — units/gherkin-review/fixtures/fixture-unverifiable-then.feature

Verdict: **NEEDS WORK** (1 must-fix)

| Severity | Location | Guideline | Finding |
|----------|----------|-----------|---------|
| must-fix | Scenario: A confirmation email is sent after checkout | Steps: language and semantics | `Then everything works as expected` has no observable, checkable outcome — a runner cannot settle it, and it never asserts the behavior the title names (an email being sent) — fix: replace with the concrete effect, e.g. `Then a confirmation email is sent to the customer's address` and, if needed, `And the email references order "ORD-2214"`. |

The second scenario (subject contains "ORD-2214") is a good observable assertion;
no other findings.

Next station: fix the `Then` and re-run this review, or walk through the fix
together — your call.
