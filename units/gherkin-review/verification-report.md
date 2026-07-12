# verification-report.md — gherkin-review

*Iteration 1 — 2026-07-12. Verifier: the `verification-report` procedure, with
`check_validation.py` as the mechanical runner for the Validation layer (see
FN-6) and an LLM judge for the Evaluation layer (self-scored this run — see the
disclosure below and FN-5).*

## Validation layer — executed via `check_validation.py` (exit 0)

| Scenario | Check executed | Result |
|----------|----------------|--------|
| Seeded violation caught (unverifiable Then) | finding at seeded location, accepted citation | ✅ PASS |
| Seeded violation caught (RED w/o absence) | finding at seeded location, accepted citation | ✅ PASS |
| Seeded violation caught (malformed @eval) | finding at seeded location, accepted citation | ✅ PASS |
| Seeded violation caught (compound scenario) | finding at seeded location, accepted citation | ✅ PASS |
| Seeded violation caught (UI mechanics) | finding at seeded location, accepted citation | ✅ PASS |
| Clean standard → no must-fix findings | zero must-fix rows on `password-reset.findings.md` | ✅ PASS |
| SKILL.md conforms to family format | frontmatter + six sections present | ✅ PASS |
| RED: review never modifies reviewed files | all 8 pre-run SHA-256 checksums unchanged | ✅ PASS |
| RED: no nonexistent guideline cited | every citation in all 6 reports resolves to a real heading | ✅ PASS |

**Validation verdict: 9/9 green.** Protocol note: one skill execution per
fixture this run (the assertion is mechanical; the subject is an LLM — per the
session's layer ruling, variance is a protocol concern; a rerun that flips a
result goes to field-notes as data).

## Evaluation layer — `@eval` criteria from `gherkin-review.feature`

> **Disclosure (FN-5):** the judge this run is the same LLM/session that wrote
> the standard, the skill, and the findings under judgment, and it knows the
> thresholds — the judge-protocol separation the methodology assumes is
> collapsed. Treat these scores as **provisional pending an independent judge**
> (a fresh session or another human/agent).

| Criterion | Scale | Threshold | Score | Notes |
|-----------|-------|-----------|-------|-------|
| E1 Actionability | 0–5 | ≥4 | **4** | Every finding states the problem and a concrete fix, usually with replacement text an author can apply directly. Held back from 5: fixes weren't verified by actually applying them. |
| E2 Signal | 0–5 | ≥3 | **4** | Severities are triaged per the rubric; the clean exemplar produced zero noise findings; incidental findings (2 total across 5 fixtures) are real, not pedantic. |
| E3 Grounding | PASS/FAIL | PASS | **PASS** | Each finding's explanation was checked against the cited section's text: the observable-`Then` and one-`When→Then` rules are in *Steps: language and semantics*; the absence rule is in *Positive and negative validations*; the five-required-fields rule is in *Inline evaluation: the @eval convention*; the declarative/no-selector rule is in *Scenarios*; *Vocabulary* and *Background* match their citations. No misrepresentations found. |

**Evaluation verdict: all thresholds met, gate PASS — provisional (self-scored).**

## Overall verdict

**PASS** — Validation 9/9 via the mechanical runner; Evaluation meets every
threshold with no failed gate, flagged provisional per the disclosure. Stop
condition: PASS on iteration 1 of the bounded loop (cap N=3).

**Recommended follow-up before treating the Evaluation verdict as final:** have
an independent judge (fresh session, or the owner) re-score E1–E3 from
`runs/*.findings.md` without being shown this report.
