# skills/ — the VDD skill family

*The executable side of VDD. Where `docs/` describes the practice and `templates/`
gives you artifacts to fill in, the skills in this directory are the agent
procedures that **run** the loop. This index names every skill, defines the shared
SKILL.md format they all conform to, and — most importantly — shows how they hand
off to each other. Read this before writing or changing any single skill: the
family contract lives here, not in the individual files.*

> ⚠️ **Status: being built.** The roster below is the intended set; not all of it
> exists yet. Each skill's row says whether it's built. This index was written
> first, deliberately, so the skills are designed as a family rather than
> discovered one at a time.

---

## The core idea: skills hand off through artifacts

A VDD skill is not a black box you call and forget. Each one has an explicit
**artifact contract** — the files it reads and the files it writes. That contract
*is* the interface between skills:

```
goal-storming-facilitator  ──writes──▶  feature.feature
                                            │
                          gherkin-review ◀──┘  (reads it, reports findings)
                                            │
                        feature-implement ◀──┘  (reads the reviewed .feature,
                                                  runs the loop against it)
```

No skill reaches into another's internals. If skill A needs what skill B produces,
A reads B's output artifact. This is why the format below leads with **Inputs** and
**Outputs**: they are the public API. It's also design-decision #8 (artifacts are
self-describing) doing real work — a well-formed artifact is enough for the next
skill to pick up cold.

Some skills additionally **invoke** others as sub-steps (e.g. `feature-implement`
calls `verification-report` every loop iteration). Those composition edges are
listed per skill under **Composes with**.

---

## Activation & hand-off (how the family is driven)

Skills are **intent-triggered with offered hand-offs**, not a slash-command
assembly line the user has to clock through by hand:

- **Activation is by intent.** "Let's define what this project is for" activates
  `goal-storming-facilitator`; "build the password-reset feature" activates
  `feature-implement`. Explicit invocation still works, but natural-language intent
  is the primary trigger.
- **A skill may call sub-skills inline.** The reviewers can run *while* the
  facilitator drafts; `feature-implement` calls `verification-report` each
  iteration. These internal calls need no user prompt — they're part of the skill.
- **Between stations, the agent OFFERS the next step; the human confirms.** At a
  station boundary the agent proposes ("the standard looks complete — run a
  `gherkin-review` pass before we build?") and waits. It does **not** auto-advance.
- **The goal boundary always needs a human yes.** This is the family's expression
  of VDD's one hard line — *the LLM proposes, the human ratifies goals*. No skill
  may carry momentum from goals into building without an explicit human hand-off.
  Auto-chaining across that boundary is prohibited.

Practically: each skill's `Procedure` ends by *stating what it produced and offering
the next station*, never by silently invoking the next skill.

---

## The shared SKILL.md format

*This section is the answer to open question #6 ("what is VDD's own SKILL.md
format?"). VDD skills are valid, invocable skills — they carry standard
frontmatter so any harness that loads skills can find them — but their **body**
follows a fixed VDD structure so that every skill declares its artifact contract in
the same place. The structure is not bound to any external skill spec; it is
whatever makes the VDD loop legible.*

Every `SKILL.md` in this directory has:

```markdown
---
name: <kebab-case-name>
description: <one sentence — when to reach for this skill and what it does>
---

## Purpose
One line: what this skill is for.

## Inputs        ← the contract. Files/values this skill reads.
- `path/to/file` — what it is and why this skill needs it.

## Outputs       ← the contract. Files this skill writes or modifies.
- `path/to/file` — what this skill produces.

## Invariants    ← hard rules this skill must never break.
- e.g. "SPEC.md is never edited directly."

## Procedure     ← the numbered steps the agent follows.
1. …

## Stop conditions   ← (loop/verify skills only) the terminal states.
- **PASS** — …
- **PAUSE** — … (hand back to a human)
- **GIVE-UP** — … (bounded so the loop can't spin forever)

## Composes with     ← which sibling skills this one calls or is called by.
- calls ▶ `verification-report`
- called by ◀ `feature-implement`
```

**Why this shape.** `Inputs`/`Outputs` make the hand-off explicit and greppable.
`Invariants` pull the non-negotiables (SPEC protection, source-of-truth files) out
of the prose where they're easy to miss. `Stop conditions` force every looping
skill to declare how it terminates — VDD loops must be bounded. `Composes with`
keeps the family graph honest as the roster grows. Non-looping skills (e.g.
`vdd-bootstrap`) omit `Stop conditions`.

---

## The roster

Ordered by where they sit in the VDD flow: scaffold → author the standard → review
the standard → run the loop → verify.

| Skill | Role | Reads → Writes | Built? |
|-------|------|----------------|:------:|
| **`vdd-bootstrap`** | Scaffold a new VDD project from `templates/`. | `templates/**`, project name → `SPEC.md`, `CLAUDE.md`, `AGENTS.md`, dir skeleton | ⬜ |
| **`goal-storming-facilitator`** | Run/transcribe a Goal Storming session; emit the verification standard. | scope + existing `SPEC.md` + `docs/01` → `goals.md`, `*.feature` (with `@eval` lines), `*.rubric.md?`, SPEC constraints (proposed), concept | ⬜ |
| **`gherkin-review`** | Review a `.feature` (including `@eval` lines) against `gherkin-guidelines.md` and `evaluation-guidelines.md`. | `*.feature`, guidelines → findings report / inline suggestions | ⬜ |
| **`rubric-review`** | Review a `.rubric.md` detail file against `evaluation-guidelines.md`. | `*.rubric.md`, `evaluation-guidelines.md` → findings report / inline suggestions | ⬜ |
| **`spec-guardian`** | Enforce the SPEC.md protection rule. | a change touching `SPEC.md`, `SPEC.md` → blocks edit; writes `schema-change-proposal.md`; pauses | ⬜ |
| **`feature-implement`** | Run the VDD loop for one unit. | `*.feature` (with `@eval` lines), `*.rubric.md?`, `SPEC.md`, `CLAUDE.md` → `requirements.md`, `plan.md`, `tasks.md`, code, `verification-report.md` | ✅ |
| **`verification-report`** | Check an implementation against its standard; write the report. | `*.feature` (with `@eval` lines), `*.rubric.md?` (detail only), the code, project test tooling → `verification-report.md` | ✅ |

---

## How they compose (the family graph)

```
vdd-bootstrap
     │  (scaffolds the project once)
     ▼
goal-storming-facilitator ──┬──▶ gherkin-review   (lint the .feature)
     │                      └──▶ rubric-review    (lint the .rubric.md)
     │  (emits the reviewed verification standard)
     ▼
feature-implement ───────────────┐
     │  each iteration:           │  on detecting a needed SPEC change:
     │  calls ▶ verification-report│  calls ▶ spec-guardian → PAUSE
     │           (validate + score)│
     └── loops until PASS / PAUSE / GIVE-UP
```

Two composition facts worth pulling out, because they shape the build order:

1. **`verification-report` is both standalone and a sub-skill.** `feature-implement`
   doesn't re-implement "run the checks" — it calls `verification-report` each
   iteration. So the hard question *"how does Validation actually execute
   deterministically, and how is Evaluation scored?"* lives in
   **`verification-report`**, and `feature-implement` stays a thin loop around it.

2. **The reviewers are pre-flight guards.** `gherkin-review` / `rubric-review` can
   run inside `goal-storming-facilitator` (as it drafts) *and* inside
   `feature-implement` (as a sanity check before building against a standard). They
   never mutate the artifact; they report. Note: `gherkin-review` now covers both
   the Gherkin scenarios *and* the `@eval` lines in the `.feature` — it's the
   primary reviewer for the complete standard. `rubric-review` is narrower: it only
   applies when a `*.rubric.md` detail file exists.

---

## Build order

Per the family design, the first vertical slice is the loop core — built as a pair
because one calls the other:

1. ✅ **`verification-report`** — the verifier. Settles how Validation executes
   (deterministic: real BDD runner, scaffolded if absent, never self-certified) and
   how Evaluation is scored (LLM-as-judge, thresholds hidden from the judge).
   Everything else leans on this.
2. ✅ **`feature-implement`** — the loop that orchestrates derive → implement →
   *(verification-report)* → repeat, with bounded stop conditions (cap N=3 +
   no-progress → PAUSE).

Next, the front-of-loop and guards, roughly in order: `spec-guardian` (referenced by
`feature-implement`, so wiring it up closes a live composition edge),
`gherkin-review` / `rubric-review`, `goal-storming-facilitator`, and finally
`vdd-bootstrap` (highest leverage, lowest novelty — mostly copies `templates/`).

---

*This index defines the skill family as currently understood. Like the rest of VDD
it's a working draft — if a skill's real Inputs/Outputs turn out different from the
row above when it's built, fix the row. The contract table is only useful if it
stays true.*
