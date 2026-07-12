# skills/ — the VDD skill family

*The authoring side of VDD, as executable agent procedures. Where `docs/`
describes the practice and `templates/` gives you artifacts to fill in, the
skills here help humans **write, grade, and push on** verification standards.
They end at the handoff: once the standard is good enough for a clean session
to build from, VDD's skills are done — the coding agent that consumes the
standard owns its own loop, runner, and reporting (its side of the deal is
[`../llm.txt`](../llm.txt)).*

> ⚠️ **Status: built, mostly unproven.** All five skills exist as of 2026-07-12,
> but only `gherkin-review` has been through the VDD loop itself — see *Build
> status* at the bottom. This index is the family contract — read it before
> writing or changing any single skill.
>
> **Scope note (2026-07-12).** Two earlier skills — `feature-implement` and
> `verification-report` — implemented the consuming loop inside VDD. The first
> dogfood run showed that was scope overreach (see
> `units/gherkin-review/field-notes.md`), and they were retired; their
> invariants (never weaken the standard, executed-checks-only, blind judges,
> bounded loops) survive as the contract in `llm.txt`.

---

## The core idea: skills hand off through artifacts

Each skill has an explicit **artifact contract** — the files it reads and
writes. That contract is the interface: no skill reaches into another's
internals; if skill A needs what B produces, A reads B's output artifact. A
well-formed artifact is enough for the next skill — or the eventual coding
agent — to pick up cold.

## Activation & hand-off

- **Activation is by intent.** "Let's define what this project is for" activates
  `goal-storming-facilitator`; "is this standard ready to build from?" activates
  the reviewers. Explicit invocation also works.
- **Between stations, the agent OFFERS the next step; the human confirms.** A
  blanket instruction from the human ("take this all the way to a ready
  standard") covers the stations it names.
- **The goal boundary always needs a human yes.** The LLM proposes; the human
  ratifies goals. No skill carries momentum from goals into a ratified standard
  without an explicit human hand-off.
- **The family ends at the handoff.** The last station's offer is: "this
  standard is ready — start a clean session and build against it (see
  `llm.txt`)." VDD skills never run the build loop themselves.

## The shared SKILL.md format

Every `SKILL.md` in this directory has standard frontmatter (`name`,
`description`) and this body:

```markdown
## Purpose        One line: what this skill is for.
## Inputs         The contract. Files/values this skill reads.
## Outputs        The contract. Files this skill writes or emits.
## Invariants     Hard rules this skill must never break.
## Procedure      The numbered steps the agent follows.
## Composes with  Which sibling skills this one calls / is called by.
```

`Inputs`/`Outputs` make the hand-off greppable; `Invariants` pull the
non-negotiables out of the prose. (An earlier `Stop conditions` section existed
for looping skills; with the loop out of VDD's scope, no current skill loops.)

## The roster

Ordered by where they sit in the flow: scaffold → author → grade → hand off.

| Skill | Role | Reads → Writes | Built? |
|-------|------|----------------|:------:|
| **`vdd-bootstrap`** | Scaffold VDD into a project: contract set, context files, `units/` — never clobbering what exists. | `templates/**`, `llm.txt`, guidelines, target project → project skeleton (or proposed additions) | ✅ |
| **`goal-storming-facilitator`** | Run a Goal Storming session (live group, or solo Q&A — mode chosen at step 0); emit the standard. | scope + mode, existing `spec.md`, `docs/01`, templates → `<name>.goals`, `*.feature` (with `@eval`), ancillary files, `spec.md` constraints (proposed) | ✅ |
| **`gherkin-review`** | Review a `.feature` (scenarios + `@eval`/`@verify-detail` lines) against both guidelines. | `*.feature`, guidelines → findings report (fixed table shape; report-only) | ✅ |
| **`rubric-review`** | Review a `.rubric.md` against `evaluation-guidelines.md` *and* its owning `.feature`'s `@eval` contract. | `*.rubric.md`, its `.feature`, guideline → findings report (same table shape) | ✅ |
| **`derivability-review`** | The "enough context?" check: four-questions pass + cold-derivation probe of the handoff set. | the handoff set only (`llm.txt`, `.goals`, `*.feature` + pointed files, `spec.md`) → derivability report (cold reading + gaps) | ✅ |

## How they compose

```
vdd-bootstrap
     │  (scaffolds once)
     ▼
goal-storming-facilitator ──┬──▶ gherkin-review      (lint the .feature)
     │                      ├──▶ rubric-review       (lint ancillary rubrics)
     │                      └──▶ derivability-review (would a cold session
     │                                                build the right thing?)
     ▼
HANDOFF — a clean coding-agent session reads llm.txt + .goals + .feature +
spec.md and builds, looping until the verifications pass. Not a VDD skill.
```

`derivability-review` is the family's most distinctive station: `gherkin-review`
checks that a standard is *well-formed*; `derivability-review` checks that it is
*sufficient* — that its verifications carry low enough variance and enough
context for the builder VDD will never meet. Its natural mechanism is the
round-trip probe from `evaluation-guidelines.md`: have a fresh session derive
requirements from the standard alone, then diff against the authors' intent.

## Build status & what validation remains

All five skills are built (2026-07-12). How they were built differs, and the
difference matters for how much to trust each:

- `gherkin-review` went through the full VDD loop as the first dogfood unit
  (`units/gherkin-review/` — ratified goals, a `.feature` standard, a
  mechanical checker, 9/9 validation). It has earned the most trust.
- The other four were **authored directly** against this family contract, not
  dogfooded. They are consistent and complete on paper; none has run a real
  session yet.

The outstanding validation work, in order of value: run `derivability-review`
for real with the split-session protocol (one session authors a standard, a
fresh one probes it); an end-to-end pilot of the whole flow (bootstrap → storm
→ review → clean-session build) on a small real project; an independent
re-score of the first dogfood's Evaluation layer (`units/gherkin-review/`
FN-5).

---

*This index defines the family as currently understood. If a skill's real
Inputs/Outputs turn out different when built, fix the row — the contract table
is only useful if it stays true.*
