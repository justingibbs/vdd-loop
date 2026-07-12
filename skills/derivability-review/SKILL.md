---
name: derivability-review
description: Check whether a unit's verification standard carries enough context —
  and low enough variance — for a cold coding-agent session to build the right
  thing from it alone. Runs a static four-questions pass and a cold-derivation
  probe, then reports where the standard is underdetermined. Report-only.
---

## Purpose

Guard the handoff. `gherkin-review` checks that a standard is *well-formed*;
this skill checks that it is *sufficient* — that the builder VDD will never
meet could read it cold and converge on what the authors meant.

## Inputs

**Exactly the handoff set, nothing more** (this restriction is the method):

- `llm.txt` — what the cold builder will be told about VDD.
- `units/<name>/<name>.goals` and `units/<name>/*.feature` — the standard.
  **Read-only.**
- every file the `.feature` declares via `@eval-detail` / `@verify-detail`.
  **Read-only.**
- `spec.md` / `SPEC.md` — the constraints the builder inherits. **Read-only.**

Explicitly **excluded**: the Goal Storming conversation, session worksheets,
authors' working notes, and anything else a clean session would not see.

## Outputs

- a **derivability report** — in conversation, and written to a file when the
  caller asks. Fixed shape:

  ```markdown
  ## derivability-review — units/<name>/

  Verdict: **DERIVABLE** (no blocking gaps) | **UNDERDETERMINED** (<n> blocking)

  ### The cold reading
  [3–8 sentences: what a cold builder would conclude this unit is, and the key
  design decisions it would make — written from the handoff set alone.]

  ### Gaps and divergences
  | Severity | Location | Type | Gap |
  |----------|----------|------|-----|
  | blocking | Scenario: <title> | ambiguity | <what two builders would read differently> — add: <what would settle it> |
  ```

  `Type` is one of: `ambiguity` (readable two ways), `missing-context` (a term,
  system, or dependency the standard assumes but never states),
  `unstated-assumption` (environment/tooling the authors had in their heads),
  `high-variance-verification` (a check whose method or pass condition a
  builder must guess at), `contract-gap` (an ancillary file that leaves one of
  the four questions unanswered).

## Invariants

- **Read-only.** This skill reports gaps; it never patches the standard, and it
  never "helpfully" supplies the missing context in place of the authors —
  context the authors didn't ratify isn't the standard.
- **The probe stays cold.** The derivation in step 3 uses only the handoff set.
  If this session already holds authoring context (it facilitated the Goal
  Storming), say so in the report and prefer a genuinely fresh session or
  subagent for the probe when one is available — a warm probe is a weaker probe.
- **Findings name the fix's *location*, not its content** — "state which user
  store password-reset tokens live in" — so the authors decide the answer.
- **Offer, don't advance.** End by offering revision (back to the authors /
  `goal-storming-facilitator`) or, on DERIVABLE, the handoff itself.

## Procedure

1. **Assemble the handoff set** per Inputs, and confirm every `@eval-detail` /
   `@verify-detail` pointer resolves. A dangling pointer is an automatic
   `contract-gap` (blocking).
2. **Static pass — the four questions.** For each scenario, `@eval` criterion,
   and ancillary file, check the standard answers: what is verified; on what
   inputs; by what method and executor; what counts as pass. Flag every
   unanswered question, plus undefined domain terms, unnamed external systems,
   and thresholds or scales a builder would have to invent.
3. **Cold-derivation probe.** From the handoff set alone, derive what a builder
   would: a short requirements sketch and the 3–6 load-bearing design decisions
   (data owner, interfaces, failure behavior, tooling). Where the set forces a
   *choice the authors never constrained*, that choice is a finding — the
   builder's coin-flip is the variance being measured. Run the probe in a fresh
   session/subagent when available; otherwise derive strictly from the set and
   disclose that the probe was simulated.
4. **Diff against intent.** Present the cold reading to the authors (humans, or
   the facilitator session acting for them) and ask one question: *"is this
   what you meant?"* Every "no, actually—" is a divergence; record it with
   where the standard permitted it.
5. **Write the report** in the fixed shape. Severity: `blocking` — a reasonable
   builder would likely build the wrong thing; `risky` — could go either way;
   `note` — friction, not danger.
6. **Close** with the verdict and the offer: on UNDERDETERMINED, revising the
   standard with the authors; on DERIVABLE, the handoff (a clean session builds
   against the standard per `llm.txt`). Invoke neither yourself.

## Composes with

- runs after ▶ `gherkin-review` (well-formed first, sufficient second).
- feeds back to ◀ `goal-storming-facilitator` — gaps go to the authors, not
  into the files directly.
- guards the HANDOFF — the last station before a clean session builds.
