## gherkin-review — examples/password-reset/password-reset.feature

Verdict: **PASS** (no must-fix findings)

| Severity | Location | Guideline | Finding |
|----------|----------|-----------|---------|

No findings. The file is a model of the guidelines: header ties to its GREEN
goal and declares the deliberate absence of an Evaluation layer; one behavior
per scenario; every `Then` observable; every RED scenario asserts the absence
of the forbidden effect (`the account password is unchanged`, `no reset link is
sent`); Givens are state-based; data is concrete; vocabulary is consistent
throughout.

Next station: this standard is ready for a coding agent to build against — proceed when you
are.
