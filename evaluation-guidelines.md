# evaluation-guidelines.md

*How to write a good `.rubric.md`. This is the standard for the **Evaluation**
technique, the judgment-based half of Verification. Its sibling,
`gherkin-guidelines.md`, plays the same role for the **Validation** technique
(`.feature` files).*

*Unlike `gherkin-guidelines.md`, which is forked from an existing source, this
guide is written from scratch — there is no upstream standard for evaluation
rubrics to adapt. Treat it as the working standard, refined as the practice
matures.*

---

## Where this fits

```
VERIFICATION  ("what proves this is done?")
├── Validation  (deterministic, binary)  → .feature   ← gherkin-guidelines.md
└── Evaluation  (scored, judgment-based) → .rubric.md  ← THIS GUIDE
```

Evaluation criteria come from Goal Storming's 🟦 BLUE cards. The verifier scores a
feature's output against them and records the result in `verification-report.md`.
A feature passes only when **both** layers meet their standard.

---

## First: should this even be an evaluation?

The most common rubric mistake is writing one at all when a validation would do.

**Reach for a rubric only when the outcome genuinely has no single correct answer.**
Summarization quality, tone, relevance, classification judgment, helpfulness — these
resist a deterministic assertion. If you can write an assertion that's either true
or false, it belongs in a `.feature` file, not here.

A useful test: *two careful reviewers could score this differently and both be
defensible.* If yes, it's an evaluation. If any competent reviewer would give the
same binary answer, it's a validation — move it to the `.feature` file.

Corollary: **most features need no rubric at all.** A rubric is a cost — it needs a
judge, a scale, and an evaluation set. Only pay it where judgment is unavoidable.
When a hard, objective floor exists under a soft quality (e.g. a 150-word cap under
"be concise"), put the floor in the `.feature` file and the softer quality here;
they check different things and both can exist.

---

## Anatomy of a well-formed criterion

Every criterion must have three properties. A criterion missing any of them is not
well-formed and should be rejected in review.

### 1. Falsifiable

You can state, concretely, what would make the criterion score low. If you can't
name the evidence that would fail it, the judge can't apply it consistently and two
runs will disagree.

- ✅ *"Faithfulness: every claim in the summary is supported by the source."*
  Falsifiable by pointing to a sentence with no support.
- ❌ *"The summary is high quality."* Nothing to point at.

Write a one-line **"Falsifiable by:"** clause on each criterion naming the evidence
that would fail it. If you can't write that line, the criterion isn't ready.

### 2. Scored on a defined scale

The scale is stated, and **each level is described**, not left as a bare number. A
judge given "score 0–5" with no anchors invents its own anchors and drifts. A judge
given "4 = fully supported, at most a harmless paraphrase" applies a shared bar.

Describe at least the threshold level and the levels adjacent to it — that's where
scoring decisions actually happen.

### 3. Explicit pass threshold

State the score at which the criterion passes. "Faithfulness 0–5" is not a
standard; "Faithfulness ≥ 4" is. Without a threshold there is no pass/fail, and the
loop has no stop condition.

---

## Choosing a scale

Two scales cover nearly everything. Pick per criterion, not per file — a single
rubric may mix them.

### 0–5 graded scale — for qualities that degrade gradually

Use when a criterion can be *more or less* satisfied and partial credit is
meaningful (faithfulness, completeness, conciseness, relevance).

Convention: `0` = absent or opposite, `3` = acceptable, `5` = exemplary. Set the
threshold where "good enough to ship" actually sits — usually `≥ 4` for
quality-critical criteria, `≥ 3` for nice-to-haves.

### PASS / FAIL gate — for hard lines that must not be averaged away

Use when a single violation should block the feature regardless of how good
everything else is (neutrality, safety, no-blame, no-verdict, policy compliance).

The reason to make something a gate rather than a low-scoring criterion: **a gate
is not averaged.** A rubric that scored neutrality 0–5 could let one blame-assigning
summary hide inside a high mean. A gate fails the whole criterion on the first
violation, which is the correct behavior for a hard line.

> Rule of thumb: if a single bad instance is unacceptable, it's a gate. If quality
> is a matter of degree, it's a 0–5 score.

---

## The judge protocol

State, in the rubric, **how criteria get scored**. At minimum:

- **Who/what judges.** LLM-as-judge, human reviewer, or LLM with human override.
  Default to LLM-as-judge with human override available.
- **What the judge sees.** The source input and the produced output — and,
  importantly, **not the threshold values.** Showing the judge the pass bar anchors
  it toward the bar. Score first, compare to threshold second.
- **Determinism caveat.** Judgment scores vary run to run. Acknowledge it and
  design the pass condition to tolerate it (below), rather than pretending scores
  are stable.

---

## Evaluate over a set, not a single case

A rubric scored on one example proves almost nothing — one lucky output isn't a
standard. Score each criterion over a **fixed evaluation set** of representative
cases (happy path, hard cases, adversarial cases).

The aggregate pass condition then reads:

- **Graded (0–5) criteria** pass when the **mean over the set** meets the threshold.
- **Gate (PASS/FAIL) criteria** pass only when **every case passes** — one failure
  anywhere fails the gate. Gates are never averaged.

Write the aggregate condition explicitly in the rubric as a checklist, so the
verifier and the loop share one definition of "the Evaluation layer passed."

---

## File organization

- **One `.rubric.md` per feature**, living in `/evaluations/[feature-name].rubric.md`.
  It carries all of that feature's evaluation criteria — multiple criteria, mixed
  scales, in one cohesive file. (Split into multiple files only if one feature's
  rubric genuinely becomes unwieldy; cohesion is the default.)
- **Header** should name what's being evaluated and reference this guide.
- **Only exists when needed.** A pure-Validation feature has no rubric at all — its
  `verification-report.md` shows an empty Evaluation section by design.

### Recommended criterion template

```
### E{n} — {Name}  *(scale: 0–5, threshold ≥ {t}   |   or: PASS / FAIL)*

{One sentence: what this criterion judges.}

| Score | Meaning |          ← for 0–5: describe the threshold level and its
|-------|---------|            neighbors, at least
| 5 | … |
| {t} | … |
| ≤{t-1} | … |

*Falsifiable by:* {the evidence that would fail it}
```

Close the file with an **Aggregate pass condition** checklist covering every
criterion and its threshold.

---

## Criterion hygiene

- **Independence.** Criteria should measure different things. If E1 and E3 rise and
  fall together, merge them or sharpen the distinction — correlated criteria give a
  false sense of coverage.
- **Traceability.** Each criterion should trace to a goal (🟩) via a BLUE card, and
  be referenced by a requirement in the feature's `requirements.md`. A criterion
  serving no goal is scope creep.
- **No deterministic criteria in disguise.** If a "criterion" is really an
  assertion ("is under 150 words"), it belongs in the `.feature` file. Don't spend
  a judge on something a check can settle.

---

## Anti-patterns

- **Vibe criteria** — "is high quality", "feels right." Not falsifiable. Reject.
- **Numbers without anchors** — a 0–5 scale whose levels aren't described. The judge
  drifts. Describe the levels.
- **Missing threshold** — a scale with no pass bar. There's no stop condition.
- **Averaging a hard line** — scoring neutrality/safety 0–5 so one violation hides
  in the mean. Make it a gate.
- **Single-case scoring** — declaring the layer passed on one good output. Score
  over a set.
- **Anchoring the judge** — handing the judge the threshold. Score blind, compare
  after.
- **Rubric for a deterministic outcome** — reaching for Evaluation where Validation
  would settle it. Prefer the `.feature` file.

---

## Worked example

`examples/dispute-summary/evaluations/dispute-summary.rubric.md` is written to this
guide: four criteria (three 0–5, one PASS/FAIL gate), each with described levels, a
"Falsifiable by" clause, a stated threshold, a judge protocol that withholds the
thresholds from the judge, and an aggregate pass condition scored over a 12-dispute
set. Its `verification-report.md` shows the loop reacting to a sub-threshold mean
(E3) and a gate failure (E2) — the two distinct failure shapes this guide predicts.

---

*This guide defines the Evaluation standard as currently understood. It is the
newest and least-settled artifact in VDD — expect it to evolve as more rubrics are
written against it.*
