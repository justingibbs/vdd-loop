# Pilot: settle-up — the first end-to-end run of the VDD flow

*2026-07-12. The flagship claim — a clean session reads the standard files and
builds working software, using the verifications to know when it's done — had
never been tested. This pilot tested it. **It held.***

## The setup

A small real project: `settle-up`, a CLI that reads a shared-expense CSV
ledger and prints who pays whom, exact to the cent. Pure-Validation standard
(no `@eval` layer, by design — the Evaluation layer was exercised by the
`units/gherkin-review/` dogfood).

Three genuinely separate contexts, on purpose:

- **Authoring session** — ran bootstrap, Goal Storming (owner ratified G1–G3),
  wrote the standard, ran `gherkin-review` on it.
- **Cold probe** (fresh subagent, read-only) — the `derivability-review` pass:
  given only the handoff set, reported its cold reading and every design
  coin-flip the standard forced.
- **Cold builder** (second fresh subagent) — given only the project path and
  the contract; built, wired `behave`, looped until green.

## Station-by-station results

1. **`vdd-bootstrap`** — scaffolded contract set + context files. Uneventful.
2. **Goal Storming** — goals ratified; standard hardened into
   `settle-up.goals` + `settle-up.feature` + SPEC constraints.
3. **`gherkin-review`** — caught a real authoring bug pre-handoff: a RED
   scenario titled "no participants" whose CSV actually had an empty *amount*
   (it would have verified the wrong defect). Fixed before handoff.
4. **`derivability-review`** — verdict DERIVABLE, **0 blocking / 8 risky / 7
   note gaps**, clustered exactly where the skill predicts: input-validation
   grammar, undefined non-ledger failures, and verification self-grading
   (including a sharp catch: the RED property steps could have circularly
   verified the tool against itself). All risky gaps closed → SPEC 1.0.0 →
   1.1.0. Full probe report: [`derivability-probe-report.md`](derivability-probe-report.md).
5. **The handoff** — the cold builder went green in **1 iteration** (cap 5):
   `8 scenarios passed, 38 steps passed, 0 failed`. It exercised the tool only
   via subprocess, wrote an independent balance oracle for the property steps
   (importing nothing from the code under test), and verified the standard
   checksums voluntarily. It explicitly credited the derivability pass:
   *"removed essentially all guesswork."* Full report:
   [`builder-report.md`](builder-report.md).
6. **Independent audit** (authoring session) — checksums of all five standard
   files byte-identical; behave re-run reproduced 8/8; two probes of SPEC-only
   rules never pinned by any scenario both passed (negative amount → line
   error, exit 1; missing file → `settle error`, exit 2).

## What's in this folder

```
project/            The complete pilot project as built (standard, SPEC 1.1.0,
                    reviews, implementation, behave steps) — re-runnable:
                    create a venv, pip install behave, behave units/settle-up
derivability-probe-report.md   The cold probe's full findings
builder-report.md              The cold builder's full report
field-notes.md                 What the pilot taught us — the real deliverable
```

## The one-line result

**Probe → tighten → hand off cold → green in one iteration → audit clean.**
The causal story VDD proposes actually happened, in order, with receipts.
