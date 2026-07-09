# evaluation-guidelines.md

*How to write a good `.rubric.md`. This is guidance for the **Evaluation**
technique, the judgment-based half of Verification. Its sibling,
`gherkin-guidelines.md`, plays the same role for the **Validation** technique
(`.feature` files).*

*Unlike `gherkin-guidelines.md`, which is forked from an existing source, this is
written from scratch — there is no upstream standard for evaluation rubrics to
adapt. Treat it as a working guide, not a rulebook, and expect it to evolve.*

---

## Where this fits

```
VERIFICATION  ("what proves this is done?")
├── Validation  (deterministic, binary)  → .feature          ← gherkin-guidelines.md
└── Evaluation  (scored, judgment-based) → @eval lines in .feature
                                           + optional .rubric.md  ← THIS GUIDE
```

Evaluation criteria come from Goal Storming's 🟦 BLUE cards. They live as `@eval`
comment lines directly in the `.feature` file — one line per criterion, inline with
the deterministic scenarios. A separate `.rubric.md` is optional expansion for
criteria whose anchor descriptions can't fit inline. The verifier reads both and
records the result in `verification-report.md`.

See **Inline evaluation: the `@eval` convention** below for the exact format.

---

## The spirit before the mechanics

Read this section first. The rest of this file is a toolkit; this is the point.

**A verification is whatever credibly proves a goal was hit.** The scored scales,
the gates, the LLM-judge protocol, the evaluation sets below — those are *common,
well-worn ways* to prove a judgment-based goal. They are a starting toolkit, **not
the definition of an evaluation and not a required process.** If a goal is better
proven by something not in this catalog — regenerating the input from the output and
checking round-trip fidelity, an adversarial probe, a pairwise comparison against a
reference answer, a quick human spot-check — **do that instead.** Inventing a fitting
verification is squarely within the practice, not a deviation from it.

**The exercise is the push.** The value of VDD is in genuinely trying to answer *"what
would prove this?"* for each goal. Push hard on that question — reach past the obvious,
try to find a verification even for the fuzzy goals. That push is where the method pays
off.

**But it doesn't gate.** You are allowed to define a goal and not yet have a
verification for it. An unverified goal is a **known gap to revisit**, not a blocked
state and not a failure. This isn't a 100%-buttoned-up process — it's a direction to
build in. Mark the gap, keep moving, come back to it. A goal you can only *partly*
verify, verified partly, still beats a goal no one tried to verify.

**The north star, when you do write a verification: it should be able to fail.** A
verification that can't distinguish a good result from a bad one proves nothing. This
is a quality to strive for, not a gate to pass — but it's the single most useful thing
to hold in mind while writing one.

---

## When to reach for an evaluation at all

Prefer a deterministic **validation** whenever one is possible — it's cheaper and
surer. Reach for an evaluation (this file) only when the outcome genuinely has no
single correct answer: summarization quality, tone, relevance, classification
judgment, helpfulness.

A useful test: *two careful reviewers could score this differently and both be
defensible.* If yes, it's an evaluation. If any competent reviewer would give the
same binary answer, it's a validation — put it in the `.feature` file.

**Most features need no rubric at all.** A rubric is a cost. Only pay it where
judgment is unavoidable. When a hard objective floor exists under a soft quality
(a 150-word cap under "be concise"), put the floor in the `.feature` file and the
softer quality here — they check different things and both can exist.

---

## The common toolkit

These are the patterns that come up most often. Reach for one when it fits; combine
them; ignore any that don't serve the goal; invent when none do.

### Pattern — the scored criterion

A named quality, scored on a scale, with a level of "good enough." The workhorse of
most rubrics.

- **0–5 graded scale** — for qualities that degrade *gradually* and where partial
  credit is meaningful (faithfulness, completeness, conciseness, relevance).
  Convention: `0` = absent/opposite, `3` = acceptable, `5` = exemplary.
- Describe the levels, don't leave bare numbers. A judge given "score 0–5" invents
  its own anchors and drifts; a judge given "4 = fully supported, at most a harmless
  paraphrase" applies a shared bar. Describe at least the "good enough" level and its
  neighbors — that's where scoring decisions actually happen.
- Give it a **threshold** — the score at which it's good enough to ship. Without one,
  there's no sense of pass, and the loop has no stop signal. (Set it where "good
  enough" genuinely sits — often `≥ 4` for quality-critical qualities, `≥ 3` for
  nice-to-haves.)

### Pattern — the PASS/FAIL gate

For a hard line that must not be averaged away — a single violation should block
regardless of how good everything else is (neutrality, safety, no-blame, no-verdict,
policy compliance).

The reason to make something a gate rather than a low score: **a gate is not
averaged.** A quality scored 0–5 could let one bad instance hide inside a high mean;
a gate fails on the first violation, which is the right behavior for a hard line.

> Rule of thumb: if a single bad instance is unacceptable → gate. If quality is a
> matter of degree → scored scale.

### Pattern — the judge protocol

When something (usually an LLM) is scoring the output, say how:

- **Who/what judges** — LLM-as-judge, human reviewer, or LLM with human override.
- **What the judge sees** — the source input and the produced output, and usually
  *not* the threshold values (showing the judge the pass bar anchors it toward the
  bar; score first, compare after).
- **Determinism caveat** — judgment scores vary run to run. Design for it rather than
  pretending scores are stable.

### Pattern — score over a set, not one case

One lucky output isn't a standard. Where you can, score over a **fixed set** of
representative cases (happy path, hard cases, adversarial cases). Then: scored
criteria pass on the **mean over the set**; gates pass only when **every case
passes**.

### Other forms worth knowing (non-exhaustive)

When the scored-criterion pattern doesn't fit the goal, these often do — and this
list is itself just a prompt, not a boundary:

- **Round-trip / reconstruction** — can the source be recovered from the output? Good
  for summaries, compressions, translations.
- **Pairwise / reference comparison** — is output A better than a baseline, or close
  enough to a gold reference? Good when absolute scoring is hard but comparison is easy.
- **Adversarial probe** — does a skeptic trying to break the output succeed? Good for
  safety and robustness.
- **Human spot-check** — a lightweight human read on a sample. Legitimate, especially
  early, when you don't yet trust an automated judge.

---

## A recommended shape (when you use scored criteria)

If you do reach for the scored-criterion pattern, this shape travels well:

```
### E{n} — {Name}  *(scale: 0–5, threshold ≥ {t}   |   or: PASS / FAIL)*

{One sentence: what this criterion judges.}

| Score | Meaning |          ← describe the threshold level and its neighbors
|-------|---------|
| 5 | … |
| {t} | … |
| ≤{t-1} | … |

*Could fail if:* {name the evidence that would score it low}
```

The *"Could fail if:"* line is the most valuable habit here — it's how you check a
criterion can actually fail before you rely on it. Close the file with an **aggregate
pass condition** so the verifier and the loop share one definition of "the Evaluation
layer passed for now."

### File organization

Evaluation criteria live in the `.feature` file, not a separate file by default:

- **Inline `@eval` lines in the `.feature`** — the primary home for all evaluation
  criteria. One line per criterion, placed after the Feature description block,
  before the first Scenario. This is what makes the `.feature` the complete
  verification standard for a unit.
- **Optional `.rubric.md`** — for criteria whose anchor descriptions, judge
  protocol, or evaluation-set instructions can't fit in a line or two. Pointed to
  from the `@eval-detail` line in the `.feature`. Lives in the unit folder alongside
  the `.feature`.
- **Only a `.rubric.md` exists when a criterion genuinely needs it.** Many
  evaluation criteria — especially simple gates — need nothing beyond an `@eval`
  line. A pure-Validation feature has neither `@eval` lines nor a `.rubric.md`; its
  `verification-report.md` notes "no Evaluation layer" by design.

---

## Inline evaluation: the `@eval` convention

Evaluation criteria are written as `#` comment lines in the `.feature` file.
Gherkin parsers skip comments, so the file remains executable without modification.

### Format

```
# @eval | <id> | <name> | <scale> | <threshold> | <description>
# @eval-detail | <relative-path-to-rubric.md>
```

**Fields** (all required on every `@eval` line):

| Field | Rules | Examples |
|---|---|---|
| `id` | Alphanumeric, unique within the file, no spaces | `E1`, `faithfulness`, `tone` |
| `name` | 2–4 words; used as the column header in the verification report | `Faithfulness`, `Tone gate` |
| `scale` | Exactly one of: `0-5`, `0-10`, `PASS/FAIL`, `0-100` | `0-5`, `PASS/FAIL` |
| `threshold` | `≥N` for numeric scales; `PASS` for PASS/FAIL | `≥4`, `≥3`, `PASS` |
| `description` | One sentence: what the judge is assessing. What the judge sees. | `Summary uses only facts from source` |

**`@eval-detail`** (optional): points to a `.rubric.md` for anchor descriptions,
judge protocol, or a multi-case evaluation set. The parser trims whitespace around
` | ` separators — field values do not need to be aligned.

### Placement

Place `@eval` lines after the Feature description block (the `As a / I want / So
that` lines), before the first `Scenario`. Reading order: intent → what gets
judged → deterministic scenarios.

### Examples

Criterion with a pointer to a detail rubric:

```gherkin
Feature: Dispute summary
  As a reviewer
  I want a concise summary of a dispute
  So that I can route it without reading the full case file

  # @eval | E1 | Faithfulness  | 0-5       | ≥4   | Summary uses only facts present in the source case file
  # @eval | E2 | Neutrality    | PASS/FAIL | PASS | Summary attributes claims without assigning blame or verdict
  # @eval | E3 | Routing facts | 0-5       | ≥4   | Summary contains what, amount, date, and customer reason
  # @eval | E4 | Conciseness   | 0-5       | ≥3   | No filler or restatement beyond what aids routing
  # @eval-detail | dispute-summary.rubric.md

  Scenario: Summary stays within length cap
    ...
```

Simple gate — no pointer needed:

```gherkin
Feature: Email notifications

  # @eval | tone | Tone | PASS/FAIL | PASS | Notification reads naturally, not robotic or mechanical

  Scenario: Welcome email sends on registration
    ...
```

### When a unit has multiple `.feature` files

When a unit folder holds several `.feature` files (`auth.feature`,
`loading.feature`, etc.), `@eval` lines belong in whichever file the criterion
naturally concerns. `verification-report` scans all `.feature` files in the unit
folder to collect the full Evaluation picture — no duplication, no designated
"primary" file.

---

## Habits worth keeping

Not rules — habits that make a verification more trustworthy:

- **Try to make it able to fail.** If you can't picture what would score it low, it
  probably can't distinguish good from bad yet. (See the north star, above.)
- **Independence.** Criteria should measure different things. If two rise and fall
  together, merge them or sharpen the distinction.
- **Traceability.** A criterion ideally traces to a goal (🟩) and is referenced by a
  requirement. A criterion serving no goal is probably scope creep.
- **Don't put deterministic checks here.** If it's really an assertion ("under 150
  words"), it belongs in the `.feature` file — don't spend a judge on it.
- **Don't average a hard line.** If one violation is unacceptable, make it a gate.
- **Don't force a rubric onto a deterministic outcome** — prefer the `.feature` file.

These are things to *strive for*. A rubric that misses some of them is still worth
having if it makes you push on "what would prove this?"

---

## Worked example

`examples/dispute-summary/dispute-summary.rubric.md` shows one good
instance built from this toolkit: four scored/gated criteria with described levels and
"could fail if" lines, a judge protocol that withholds thresholds, and a set-based
pass condition. It's *an* example of these patterns in use — not the required form. A
different feature might prove its goal a completely different way.

---

*This guide is the newest and least-settled artifact in VDD. It documents what has
worked so far and deliberately leaves room to invent what hasn't been tried yet.*
