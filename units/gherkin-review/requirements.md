# requirements.md — gherkin-review

## Goals (🟩 — the spine, ratified 2026-07-12)

- **G1** — An author can find and fix what's wrong with their standard without
  rereading the guidelines: findings are located, explained, guideline-traceable.
- **G2** — Loop-corrupting defects are caught before `feature-implement` builds
  against the standard.
- **G3** — The verdict is meaningful: the review can genuinely fail a bad
  standard.

## Design Concept (🟪)

> A lint pass for your verification standard — it tells you where the standard
> can't be trusted, and never touches it.

## Requirements

Each requirement traces to the scenario(s) / `@eval` criteria it serves in
`gherkin-review.feature`.

- **R1 — Complete coverage of the standard.** The skill reviews both the Gherkin
  scenarios and the `@eval` lines of every `.feature` it is pointed at, against
  `gherkin-guidelines.md` and `evaluation-guidelines.md` respectively.
  *(→ seeded-violation outline rows 1–5; constraint ⬛)*
- **R2 — Located findings.** Every finding names the scenario title (or line)
  it concerns. *(→ "location matches the manifest entry"; G1, E1)*
- **R3 — Cited findings.** Every finding cites one guideline section by its
  heading text — a real section, never an invented rule. *(→ "cites a guideline
  section"; RED no-nonexistent-citation; E3)*
- **R4 — Severity triage.** Findings carry exactly one severity: `must-fix`
  (the standard can't be trusted as loop input), `should-fix` (weakens the
  standard), or `consider` (style/polish). *(→ clean-exemplar scenario keys off
  `must-fix`; G3, E2)*
- **R5 — Actionable text.** Each finding states what is wrong *and* how to fix
  it, in the finding itself. *(→ E1)*
- **R6 — Machine-checkable report shape.** Findings are emitted as a fixed-shape
  markdown table (`severity | location | guideline | finding`) so a mechanical
  checker can verify R2–R4 without judgment. *(→ enables the whole Validation
  protocol)*
- **R7 — Read-only.** The skill never modifies the file under review, the
  guidelines, or any source-of-truth artifact. *(→ RED checksum scenario; ⬛)*
- **R8 — Family conformance.** `skills/gherkin-review/SKILL.md` carries the
  shared frontmatter and the six family sections, omitting Stop conditions
  (non-looping). *(→ family-format scenario; ⬛)*
- **R9 — Offer, don't advance.** The procedure ends by stating the verdict and
  offering the next station (fix-and-rerun, or proceed to `feature-implement`).
  *(→ ⬛; family activation rule)*

## Out of scope

- Reviewing `.rubric.md` detail files (that is `rubric-review`, the narrower
  sibling).
- Fixing the file under review (report-only; the author decides).
- Judging whether the *goals* behind the standard are right (Goal Storming's
  job, not lint's).
