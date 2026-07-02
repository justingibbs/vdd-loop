# dispute-summary.rubric.md

*The Evaluation layer for the dispute-summary feature. Output of Goal Storming's
🟦 BLUE cards. Where `.feature` scenarios are checked deterministically, these
criteria are **scored by judgment** — an LLM-as-judge or a human reviewer — because
the outcomes have no single correct answer.*

*Written to the standard in `evaluation-guidelines.md`: every criterion is
falsifiable, scored on a defined scale, and carries an explicit pass threshold.*

---

## What is being evaluated

The **summary text** produced for a dispute — the same output whose deterministic
guardrails (length cap, id reference, PII masking, fail-closed) are checked in
`dispute-summary.feature`. This rubric judges the qualities of that summary that a
guardrail cannot: is it faithful, neutral, and complete enough to route the dispute
on?

## Judge protocol

- **Judge:** LLM-as-judge, given the source dispute (complaint + transaction +
  correspondence) and the generated summary. A human reviewer may override any
  score.
- **Inputs to the judge:** source case file and the summary only. The judge does
  **not** see this rubric's threshold values, to avoid anchoring.
- **Determinism note:** scores are judgment and may vary run to run. The pass bar
  is set with that in mind — see *Aggregate pass condition*.

## Scales used in this file

This rubric mixes two scales in one file, deliberately (see *Design stance* at the
bottom):

- **0–5 quality scale** for graded qualities. `0` = absent/opposite, `3` =
  acceptable, `5` = exemplary.
- **PASS / FAIL binary gate** for a quality that is really a hard line, where a
  low-but-nonzero score shouldn't be allowed to average away a violation.

---

## Criteria

### E1 — Faithfulness  *(scale: 0–5, threshold ≥ 4)*

The summary represents the dispute using only facts present in the source. No
invented amounts, dates, parties, or motivations.

| Score | Meaning |
|-------|---------|
| 5 | Every claim in the summary is directly supported by the source. |
| 4 | Fully supported; at most a harmless paraphrase that adds no new fact. |
| 3 | One minor unsupported detail that doesn't change routing. |
| ≤2 | An invented or materially distorted fact. |

*Falsifiable by:* pointing to a sentence in the summary with no support in the source.

### E2 — Neutrality  *(scale: PASS / FAIL)*

The summary reports the dispute without assigning blame or editorializing. It
attributes claims ("the customer states…", "the record shows…") rather than ruling
on them.

- **PASS:** no language that presumes fault by either party; claims are attributed.
- **FAIL:** any wording that takes a side ("the customer was clearly overcharged",
  "an obvious fraud") or renders a verdict the reviewer is supposed to reach.

*Why a gate, not a score:* a single blame-assigning phrase can bias the reviewer,
so neutrality is pass/fail — a mostly-neutral summary with one prejudicial line
still fails.

### E3 — Routing completeness  *(scale: 0–5, threshold ≥ 4)*

The summary contains the facts a reviewer needs to route the dispute: what is
disputed, the amount, the date, and the customer's stated reason.

| Score | Meaning |
|-------|---------|
| 5 | All four routing facts present and unambiguous. |
| 4 | All four present; one slightly imprecise but still actionable. |
| 3 | One routing fact missing but inferable from context. |
| ≤2 | A routing fact missing and not inferable — reviewer must open the file. |

*Falsifiable by:* naming a routing fact a reviewer would still have to look up.

### E4 — Conciseness  *(scale: 0–5, threshold ≥ 3)*

No filler, no restatement, no boilerplate. This is the judgment-based partner to
the deterministic 150-word cap in the `.feature` file: under budget *and* dense.

| Score | Meaning |
|-------|---------|
| 5 | Every sentence carries routing-relevant information. |
| 3 | Acceptable; one or two low-value sentences. |
| ≤2 | Padded or repetitive even if under the word cap. |

---

## Aggregate pass condition

The Evaluation layer passes for a summary when **all** hold:

- [ ] E1 Faithfulness ≥ 4
- [ ] E2 Neutrality = PASS
- [ ] E3 Routing completeness ≥ 4
- [ ] E4 Conciseness ≥ 3

Scored over a fixed evaluation set of representative disputes (not a single case),
the feature passes when **every criterion meets its threshold on the mean, and no
individual dispute produces an E2 FAIL.** One neutrality failure anywhere blocks
the layer — the gate is not averaged.

---

## Design stance (resolves a brief open question)

The brief asked: *should a `.rubric.md` support multiple criteria with different
scales (0–5 vs pass/fail) in one file, or one criterion per file?* This example
takes the position: **one file per feature, multiple criteria, mixed scales
allowed** — graded qualities use 0–5, hard lines use PASS/FAIL gates. The file
stays cohesive (one feature's judgment standard in one place) while still letting a
non-negotiable quality act as a gate rather than a number that can be averaged
away. If practice shows this gets unwieldy, splitting is the fallback — but the
default is cohesion.
