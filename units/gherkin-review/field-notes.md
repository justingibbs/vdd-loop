# field-notes.md — dogfood log for the gherkin-review unit

*The point of this unit is only half the skill itself. The other half is this
file: every place the methodology bent, broke, or surprised us while vdd-loop
built its own next skill through its own loop. Raw and chronological.*

---

## FN-1 — vdd-loop has no SPEC.md of its own

Surfaced at session step 0 (frame the scope). The methodology routes BLACK cards
to `SPEC.md`, but the repo that defines the methodology has no `SPEC.md`. The
skill-family contract (`skills/README.md`) served as the de facto constraint
surface for this unit. **Implication:** either the methodology should name where
constraints live when a project has no SPEC.md yet, or vdd-loop should dogfood
harder and grow its own SPEC.md. Also touches design decision #8 — an LLM
summarizing this repo builds its picture from README/BRIEF/HANDOFF, not from VDD
artifacts, because until this unit there were none.

## FN-2 — the layer question: who runs the check vs. what the check is

The LLM participant (me) initially escalated "fixture checks of an LLM-executed
skill" into a methodology decision — YELLOW or BLUE? — because the subject is
stochastic. The owner's ruling was cleaner and is now recorded in `gherkin-review.goals`:
**the layer is defined by the nature of the check, not by what produced the
behavior being checked.** A mechanical assertion over an LLM-produced artifact is
Validation; subject variance is a protocol/test-engineering concern (like a flaky
integration test), not grounds for demotion to Evaluation. **Implication for the
docs:** neither guideline states this explicitly, and an LLM following them got
it wrong on the first real unit. One sentence in `gherkin-guidelines.md`'s
layer-boundary section would prevent the misreading.

## FN-3 — goal ratification worked, and was fast

The GREEN gate (LLM proposes, human ratifies) cost one interaction and caught
real engagement — the owner ratified all three but *interrogated the layer
question* before letting the session proceed. The hard line did its job without
ceremony.

## FN-4 — blanket instruction vs. offer-and-confirm at station boundaries

The family contract says a skill ends by *offering* the next station, never
auto-advancing. But the owner's instruction was "build gherkin-review as a VDD
unit" — a blanket authorization spanning all stations. The agent proceeded
end-to-end (session → standard → loop → report) under that authorization, pausing
only at the goal boundary. **Open question for the docs:** does a blanket human
instruction satisfy the offer-and-confirm rule for every station it spans, or
should the agent still pause at each boundary? Current call: blanket covers it;
the goal boundary alone is non-negotiable.

## FN-5 — the standard's author is also the implementer and the judge

In this unit, the same LLM (in one session) drafted the `.feature`, will
implement the skill, will execute the skill for the fixture runs, and will score
the `@eval` criteria. Three separations the methodology assumes are collapsed.
The mechanical checker (`check_validation.py`) restores independence for the
Validation layer — the script can't be sweet-talked. The Evaluation layer verdict
should be read as **provisionally self-scored**; the judge protocol's
"thresholds hidden from the judge" is impossible when the judge wrote the
thresholds an hour earlier. **Implication:** the methodology may want a named
stance on same-session self-verification (allowed-with-disclosure vs. requires a
fresh session/agent for the judge).

## FN-6 — "the runner" for a docs-only project

`verification-report` says: identify the BDD runner from CLAUDE.md; if none,
scaffold one. For a unit whose implementation is a markdown procedure, a Cucumber
scaffold would be theater. What actually honors the invariant ("validation
results come only from executed checks, never inspection") is a purpose-built
checker script with binary exit status. Scaffolded here as
`check_validation.py`. **Implication:** the runner requirement should be phrased
as "a mechanical checker whose verdict the agent cannot influence," with a BDD
runner as the default instance for code projects.

## FN-7 — fixture ambiguity: which guideline section "is" the violation

Writing `fixtures/manifest.tsv` surfaced that one defect often violates several
guideline sections at once (a compound scenario breaks both "Guiding principles"
and "Scenarios"). The manifest had to allow alternate acceptable citations per
defect. Small, but it means "cites the right guideline" is fuzzier than it
sounds; exact-match assertions would have produced false failures.

## FN-8 — run-1 verification results (see verification-report.md)

The loop hit **PASS on iteration 1** — Validation 9/9 via `check_validation.py`,
Evaluation thresholds met (self-scored, provisional per FN-5). Honest reading:
a first-iteration pass is *weak evidence*, because the implementer knew the
fixtures while writing the skill (the standard and the implementation grew in
one head — the agent-loop equivalent of writing tests after peeking at the
code). The loop never got to exercise its interesting states (red set changed /
stuck / GIVE-UP). **Implication:** the methodology's value shows in iterations
2+, and a same-session dogfood may be structurally unable to produce them.
Next dogfood should split roles: one session writes the standard + fixtures,
a different session implements against them cold.

## FN-9 — the loop's working docs earned their keep unevenly

`tasks.md` genuinely drove execution order. `plan.md` was written and then
mostly *followed from memory*, not consulted. `requirements.md`'s main value was
forcing the trace from each requirement to a scenario/criterion (R1–R9 → the
checker's assertions map). For small units, requirements+plan might collapse
into one doc without loss — worth watching on the next unit before proposing a
template change.

## FN-10 — the dogfood's biggest finding: VDD had over-built the execution side

Reviewing this unit's frictions with the owner led to the largest scope decision
so far: **VDD is authoring-side only.** The methodology's job is producing
standard files (`.goals`, `.feature`, ancillary verification docs, `spec.md`)
with enough context that a *clean-session* coding agent can build and know when
it's done; the loop, runner, working docs, and report format are that agent's
business, governed by the contract now in `llm.txt`. Consequences executed
2026-07-12: `feature-implement` and `verification-report` retired (their
invariants moved to `llm.txt`); `goals.md` became `<name>.goals`; working-doc
templates removed; `derivability-review` added to the roster. Note the arc:
FN-5 and FN-6 were *symptoms* of the overreach this decision removed —
the dogfood surfaced the friction, and the friction pointed at the scope. The
harness in this folder (`fixtures/`, `check_validation.py`, `runs/`) remains as
the record of run 1 and as a working example of what a *consuming agent* might
build to verify — exactly the kind of thing VDD itself no longer prescribes.

## FN-11 — the ad-hoc harness became the template for a convention

This unit's `manifest.tsv` and `check_validation.py` were invented with no
format to follow, and worked because the `.feature` header explained what they
were. That experience produced the ancillary-verification-files decision
(HANDOFF §3.13): a four-questions completeness contract plus a
`# @verify-detail | <path> | <what it provides>` pointer line, with specific
formats left to be earned through recurrence. This unit's `.feature` now uses
the pointer it inspired. Pattern worth noticing twice now (see FN-10): the
dogfood's improvisations, not upfront design, are what's generating VDD's
conventions — which is the methodology working as intended.
