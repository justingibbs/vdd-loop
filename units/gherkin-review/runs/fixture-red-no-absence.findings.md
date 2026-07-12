## gherkin-review — units/gherkin-review/fixtures/fixture-red-no-absence.feature

Verdict: **NEEDS WORK** (1 must-fix)

| Severity | Location | Guideline | Finding |
|----------|----------|-----------|---------|
| must-fix | Scenario: A locked account never allows login | Positive and negative validations | This RED scenario asserts only that an error message is shown, not that the forbidden effect is absent — it can pass while a session is quietly created — fix: add the absence assertion, e.g. `And no session is created` (and/or `And the account remains locked`). |
| consider | Scenario: A locked account never allows login | Vocabulary | The Given refers to `the account "maria@example.com"` while the When switches to `Maria` — fix: pick one term for the actor (e.g. `the account owner submits the correct password`) and use it throughout. |

The lockout scenario (five failures → locked for 30 minutes) is well-formed.

Next station: add the absence assertion and re-run this review, or walk through
the fix together — your call.
