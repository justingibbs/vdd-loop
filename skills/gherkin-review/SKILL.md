---
name: gherkin-review
description: Review a .feature file — its Gherkin scenarios and its @eval lines —
  against gherkin-guidelines.md and evaluation-guidelines.md, and report located,
  guideline-cited, severity-triaged findings. Report-only; never modifies the file
  under review. The primary reviewer for a complete verification standard.
---

## Purpose

Tell the author of a `.feature` file exactly where their verification standard
can't be trusted — located, explained, traceable to the guidelines — without ever
touching the file.

## Inputs

- the `.feature` file(s) under review — typically `units/<name>/*.feature`.
  **Read-only.**
- `gherkin-guidelines.md` — the rulebook for the Validation layer (scenarios).
- `evaluation-guidelines.md` — the rulebook for the `@eval` convention.
- `units/<name>/<name>.goals` *(optional)* — for checking the header ties to a
  real GREEN goal.

## Outputs

- a **findings report** — in conversation, and written to a file when the caller
  asks. Fixed shape:

  ```markdown
  ## gherkin-review — <path/to/file.feature>

  Verdict: **PASS** (no must-fix findings) | **NEEDS WORK** (<n> must-fix)

  | Severity | Location | Guideline | Finding |
  |----------|----------|-----------|---------|
  | must-fix | Scenario: <title> | <section heading> | <what is wrong> — fix: <how to fix it> |
  ```

  `Location` is one of: `Scenario: <title>`, `Scenario Outline: <title>`,
  `@eval <id>`, `Background`, `Feature block`, or `file header`. `Guideline` is
  the heading text of one section in the guidelines, as written there.

Nothing else is produced. This skill never modifies any file it reads.

## Invariants

- **Read-only.** The file under review, the guidelines, and every source-of-truth
  artifact stay byte-identical.
- **Every finding cites exactly one real guideline section** by its heading text.
  No invented rules: if no section covers the concern, it is not a finding — at
  most a closing remark outside the table. Prefer the most specific section that
  applies.
- **Every finding carries one severity** from the rubric in the Procedure, and
  states both the problem and the fix in the `Finding` cell.
- **Offer, don't advance.** End by stating the verdict and offering the next
  station; never auto-invoke another skill.

## Procedure

1. **Read** the file(s) under review, both guidelines, and `<name>.goals` if
   present.
2. **Structural pass** — file is kebab-case; at most one `Feature` block; header
   comment ties the file to its GREEN goal; every `@eval` line has all five
   fields (`id | name | scale | threshold | description`), a legal scale
   (`0-5`, `0-10`, `0-100`, `PASS/FAIL`), a threshold matching the scale
   (`≥N` / `PASS`), and sits after the Feature description block, before the
   first Scenario; any `@eval-detail` or `@verify-detail` pointer resolves to an
   existing file (and `@verify-detail` lines carry the `path | what it provides`
   pair).
3. **Scenario pass** — for each scenario: one behavior (one `When`→`Then` arc);
   strict `Given`→`When`→`Then` order; every `Then` observable and mechanically
   checkable; declarative domain language (no UI selectors, clicks, endpoints,
   SQL — unless the behavior is inherently at that layer); state-based `Given`s;
   concrete, realistic data; independent of other scenarios; fewer than ~10
   steps; no `Or` branching; consistent vocabulary across the file.
4. **RED-coverage pass** — every negative scenario asserts the **absence of the
   forbidden effect**, not merely that an error was shown.
5. **Layer-boundary pass** — a `Then` that needs judgment to settle belongs in an
   `@eval` line (flag it toward Evaluation); an `@eval` criterion any competent
   checker would settle identically belongs in a scenario (flag it toward
   Validation).
6. **Assemble the report** in the fixed shape, one row per finding, using this
   severity rubric:
   - **must-fix** — the loop would build against a lie: a vague/unverifiable
     `Then`; a RED scenario that doesn't assert the absent effect; a malformed,
     misplaced, or unresolvable `@eval` line; multiple behaviors in one
     scenario; scenarios that depend on each other; `Or` branching.
   - **should-fix** — the standard still runs but trust erodes: UI/automation
     mechanics in step text; navigation tours instead of state-based `Given`s;
     bloated `Given`/`Background`; placeholder data; vocabulary drift; missing
     goal header.
   - **consider** — style and polish: formatting, phrasing, table hygiene.
7. **Close** with the verdict and the offer: on NEEDS WORK, offer to walk through
   fixes with the author and re-review; on PASS, offer the next station —
   `derivability-review`, `rubric-review` if an `@eval-detail` rubric exists, or
   the handoff itself (a clean coding-agent session builds against the standard
   per `llm.txt`). Do not invoke any of them yourself.

## Composes with

- called by ◀ `goal-storming-facilitator` — linting the standard as it is drafted.
- sibling ▶ `rubric-review` — reviews `.rubric.md` detail files; this skill
  covers the `.feature` including its `@eval` lines.
- sibling ▶ `derivability-review` — checks sufficiency of context; this skill
  checks well-formedness. Both run before the handoff to the coding agent.
