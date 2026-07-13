## gherkin-review — units/settle-up/settle-up.feature

*Reviewed 2026-07-12, pre-handoff. One must-fix was found and fixed by the
authoring session before handoff; recorded here per the review-then-revise flow.*

Verdict at first pass: **NEEDS WORK** (1 must-fix) → fixed → **PASS** on re-review.

| Severity | Location | Guideline | Finding |
|----------|----------|-----------|---------|
| must-fix | Scenario: A row with no participants stops settlement with the line named | Scenarios | The scenario title and assertions target a missing *participants* field, but the ledger row (`alice,,alice+bob,parking`) actually had an empty *amount* — the scenario verified a different defect than it named. **Fixed:** row is now `alice,7.00,,parking` and an `And the error output mentions "participants"` assertion was added. |
| consider | Scenario: No one is ever told to pay more than they owe | Steps: language and semantics | The two property assertions ("no payment exceeds the payer's shortfall", "each creditor receives exactly their balance") require step implementations that recompute balances — heavier steps than the exact-output assertions elsewhere. Acceptable: they are deterministic and guard G2 directly; noting the weight. |

Re-review after the fix: header ties to the ratified goals and declares the
absent Evaluation layer; one behavior per scenario; every `Then` observable
(exact output, exit codes, named error lines); both RED error scenarios assert
the **absence** of settlement output, not just the error; data is concrete and
realistic; vocabulary consistent ("the ledger is settled") throughout.

Next station: `derivability-review` (cold probe), then the handoff.
