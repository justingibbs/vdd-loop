---
name: rubric-review
description: Review a .rubric.md detail file against evaluation-guidelines.md and
  against the .feature whose @eval lines point to it — checking consistency,
  anchor quality, judge protocol, and that every criterion is able to fail.
  Report-only; the narrower sibling of gherkin-review.
---

## Purpose

Tell the authors of a `.rubric.md` where their Evaluation detail can't be
trusted — before a judge scores against it. Applies only when a unit has a
rubric detail file; the `@eval` lines themselves are `gherkin-review`'s job.

## Inputs

- the `.rubric.md` under review. **Read-only.**
- the `.feature` file whose `@eval-detail` points to it — the `@eval` lines are
  the contract the rubric must match. **Read-only.**
- `evaluation-guidelines.md` — the rulebook.

## Outputs

- a **findings report** — in conversation, and written to a file when the
  caller asks. Same fixed shape as `gherkin-review`:

  ```markdown
  ## rubric-review — <path/to/name.rubric.md>

  Verdict: **PASS** (no must-fix findings) | **NEEDS WORK** (<n> must-fix)

  | Severity | Location | Guideline | Finding |
  |----------|----------|-----------|---------|
  | must-fix | E2 | Pattern — the PASS/FAIL gate | <what is wrong> — fix: <how> |
  ```

  `Location` is a criterion id (`E1`), a section name, or `file`. `Guideline`
  is a real section heading from `evaluation-guidelines.md`.

Nothing else is produced. This skill never modifies any file it reads.

## Invariants

- **Read-only.** The rubric, the `.feature`, and the guidelines stay untouched.
- **Every finding cites exactly one real guideline section**; no invented rules.
- **Every finding carries one severity** (rubric below) and states problem and
  fix in the `Finding` cell.
- **Offer, don't advance.**

## Procedure

1. **Read** the rubric, its owning `.feature`'s `@eval` lines, and the guideline.
2. **Linkage pass** — the rubric matches its contract: every rubric criterion
   corresponds to an `@eval` id in the `.feature`, and scales and thresholds
   agree between the two; no orphan criteria in either direction; the rubric
   only contains what genuinely needed expansion beyond the `@eval` line.
3. **Criterion pass** — each criterion: anchor descriptions exist at least at
   the threshold level and its neighbors (not bare numbers); a meaningful
   *"could fail if"* exists (the able-to-fail north star); criteria are
   independent (don't rise and fall together); nothing deterministic is
   smuggled in that belongs in the `.feature`; hard lines are gates, not
   low scores.
4. **Protocol pass** — the judge protocol says who judges and what the judge
   sees; **thresholds are withheld from the judge**; a fixed evaluation set is
   defined where the criteria call for scoring over a set; an aggregate pass
   condition closes the file (scored criteria on the mean, gates on every case).
5. **Assemble the report** in the fixed shape, using this severity rubric:
   - **must-fix** — the rubric would corrupt the verdict: contradicts its
     `@eval` lines (ids, scales, thresholds); a criterion that cannot fail; a
     protocol that shows the judge the thresholds; a gate averaged into scores;
     a deterministic check dressed as judgment.
   - **should-fix** — trust erosion: bare-number scales; missing "could fail
     if"; correlated criteria; no aggregate pass condition; no evaluation set
     where one is clearly needed.
   - **consider** — style and polish.
6. **Close** with the verdict and the offer: revise and re-review, or proceed
   (`derivability-review`, or the handoff). Invoke nothing yourself.

## Composes with

- sibling ◀ `gherkin-review` — reviews the `.feature` including its `@eval`
  lines; hands rubric detail here when an `@eval-detail` pointer exists.
- may be called by ◀ `goal-storming-facilitator` — inline lint while drafting.
- runs before ▶ `derivability-review` and the handoff.
