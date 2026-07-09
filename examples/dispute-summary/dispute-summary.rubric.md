# dispute-summary.rubric.md

*Optional Evaluation detail for the dispute-summary unit. The `@eval` lines in
`dispute-summary.feature` are the source of truth for criteria, scales, and
thresholds. This file provides what didn't fit inline: anchor descriptions for the
four criteria, the judge protocol, and the evaluation set definition.*

*Built from the toolkit in `evaluation-guidelines.md`. This is **one** way to prove
this unit's goal — scored criteria plus a gate, chosen because they fit summary
quality well. A different unit might prove its goal a completely different way;
nothing here is the required form.*

---

## What is being evaluated

The **summary text** produced for a dispute — the same output whose deterministic
guardrails (length cap, id reference, PII masking, fail-closed) are checked via
YELLOW + RED scenarios in `dispute-summary.feature`. This file judges the qualities
of that summary that a guardrail cannot: is it faithful, neutral, and complete
enough to route the dispute on?

## Judge protocol

- **Judge:** LLM-as-judge, given the source dispute (complaint + transaction +
  correspondence) and the generated summary. A human reviewer may override any
  score.
- **Inputs to the judge:** source case file and the summary only. The judge does
  **not** see the threshold values from the `@eval` lines, to avoid anchoring.
- **Determinism note:** scores are judgment and may vary run to run. The pass bar
  is set with that in mind — see *Aggregate pass condition*.

## Criteria detail

### E1 — Faithfulness  *(scale: 0–5, threshold ≥4 — from `@eval`)*

The summary represents the dispute using only facts present in the source. No
invented amounts, dates, parties, or motivations.

| Score | Meaning |
|-------|---------|
| 5 | Every claim in the summary is directly supported by the source. |
| 4 | Fully supported; at most a harmless paraphrase that adds no new fact. |
| 3 | One minor unsupported detail that doesn't change routing. |
| ≤2 | An invented or materially distorted fact. |

*Could fail if:* a sentence in the summary has no support in the source.

### E2 — Neutrality  *(PASS/FAIL gate — from `@eval`)*

The summary reports the dispute without assigning blame or editorializing. It
attributes claims ("the customer states…", "the record shows…") rather than ruling
on them.

- **PASS:** no language that presumes fault by either party; claims are attributed.
- **FAIL:** any wording that takes a side ("the customer was clearly overcharged",
  "an obvious fraud") or renders a verdict the reviewer is supposed to reach.

*Why a gate, not a score:* a single blame-assigning phrase can bias the reviewer,
so neutrality is pass/fail — a mostly-neutral summary with one prejudicial line
still fails.

### E3 — Routing completeness  *(scale: 0–5, threshold ≥4 — from `@eval`)*

The summary contains the facts a reviewer needs to route the dispute: what is
disputed, the amount, the date, and the customer's stated reason.

| Score | Meaning |
|-------|---------|
| 5 | All four routing facts present and unambiguous. |
| 4 | All four present; one slightly imprecise but still actionable. |
| 3 | One routing fact missing but inferable from context. |
| ≤2 | A routing fact missing and not inferable — reviewer must open the file. |

*Could fail if:* a routing fact is one a reviewer would still have to look up.

### E4 — Conciseness  *(scale: 0–5, threshold ≥3 — from `@eval`)*

No filler, no restatement, no boilerplate. This is the judgment-based partner to
the deterministic 150-word cap in the `.feature` file: under budget *and* dense.

| Score | Meaning |
|-------|---------|
| 5 | Every sentence carries routing-relevant information. |
| 3 | Acceptable; one or two low-value sentences. |
| ≤2 | Padded or repetitive even if under the word cap. |

## Evaluation set

Scored over a fixed set of 12 representative disputes:
- 4 straightforward cases (clear complaint, complete records)
- 4 ambiguous cases (missing context, conflicting accounts)
- 4 adversarial cases (PAN exposure attempts, editorializing bait in source)

The feature passes when every criterion meets its threshold on the **mean over the
set**, and no individual dispute produces an E2 FAIL.
