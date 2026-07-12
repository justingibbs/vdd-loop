# vdd-loop

**Verification-Driven Development — a standard for building software with AI
coding agents by centering the work on verifications instead of specs. Humans
(with an LLM facilitator) define what would prove the work correct; a coding
agent in a clean session builds from that standard and loops until it passes.**

> TDD proved the code. BDD proved the behavior. VDD tells the agent when it's done.

---

> ⚠️ **Status: early and experimental.** This is a working sketch, not a finished
> product. It has been dogfooded exactly once (see `units/gherkin-review/`), and
> that run reshaped it. Treat everything as a working draft, not a standard-standard.

## The idea in a breath

Most agentic-coding guidance treats the **specification** as the primary artifact
and verification as something you bolt on afterward. VDD inverts that:

```
What would prove this works?      ← Start here. The irreplaceable human judgment.
        ↓
Capture it as verifications, with enough context to build from.
        ↓
Hand it to a coding agent in a clean session.
        ↓
The agent builds — and the verifications tell it when it's done,
looping until the standard passes.
```

A spec can be satisfied by the wrong implementation. A tight verification
standard is much harder to satisfy wrongly. The agent can derive everything else
from a precise-enough statement of *what would prove this correct* — but it can't
invent that standard, because the standard is where the human says what matters.

## What VDD is — and deliberately is not

VDD is three things:

1. **Standard files.** `<name>.goals` (the outcome of Goal Storming),
   `<name>.feature` (the verification standard: deterministic **Validation**
   scenarios + judgment-based **Evaluation** criteria as inline `# @eval` lines),
   ancillary verification files (e.g. `.rubric.md` detail), and `spec.md`
   (constraints). The `.feature` is the source of truth and the done-signal.
2. **A loose folder structure.** One folder per unit of work, named like a git
   branch (`units/password-reset/`); a project build-out is a folder of feature
   subfolders. Everything for a unit lives together.
3. **Authoring skills.** Agent skills that help *write, grade, and push on*
   verifications: goal storming, `.feature` review, rubric review, and checking
   that a standard carries enough context for a cold session to build from.

VDD is **not** a harness, a loop implementation, or a report format. The coding
agent that consumes the standard owns its own working docs, its own loop, its
own runner, and its own reporting. What VDD owes that agent is one thing:
[`llm.txt`](llm.txt) — the contract that says what the files are and what makes
a "done" verdict trustworthy (standard is read-only, validation only via
executed checks, judges blind to thresholds, bounded loops, protected spec).

## The user flow

1. **Start a project** and import the skills from this repo (`vdd-bootstrap`
   scaffolds the files).
2. **Engage your agent about what you want to build.** It guides you into Goal
   Storming — goals first, then "what would prove this?" Humans ratify goals;
   the LLM proposes and challenges. Output: `.goals`, `.feature` file(s),
   constraints into `spec.md`.
3. **Grade the standard** with the review skills — including whether it carries
   enough context for a session with no memory of your conversation.
4. **Hand off.** A coding agent in a clean session reads `.feature` + `.goals` +
   `spec.md` (+ `llm.txt`) and builds — running the validations for real,
   getting the `@eval` criteria judged, looping until the standard passes or a
   human is needed.

## The two techniques

- **Validation** — deterministic, binary, machine-checkable. Gherkin scenarios
  in the `.feature`. Written against [`gherkin-guidelines.md`](gherkin-guidelines.md).
- **Evaluation** — scored, judgment-based, checked by LLM-as-judge or human.
  `# @eval` lines in the same `.feature`; optional `.rubric.md` for anchor
  descriptions. Written against [`evaluation-guidelines.md`](evaluation-guidelines.md).

The layer is defined by the nature of the *check*, not by what produced the
behavior being checked. Most features need only Validation.

## Where it came from

VDD was inspired by **Lee Boonstra's** whitepaper, *["Spec-Driven Production Grade
Development in the Age of Vibe Coding"](https://www.kaggle.com/whitepaper-spec-driven-production-grade-development-in-the-age-of-vibe-coding)*
([leeboonstra.dev](https://www.leeboonstra.dev/)). If that paper is "write the
spec well," VDD's bet is "write down what would prove it, and let the spec fall
out of that." Read the paper first — this repo is a riff on it.

## Provenance, and an honest caveat

Much of this repo was assembled **with the aid of an LLM**. An LLM will happily
produce a coherent, well-formatted methodology that is subtly about the wrong
thing. The first dogfood run (building the `gherkin-review` skill through VDD's
own process — see `units/gherkin-review/field-notes.md`) caught exactly that: the
methodology had over-built the execution side, and the scope was cut back to
what's here now. More runs will find more. **This needs to be used to find its
flaws** — consider it an invitation to break it.

## What's actually here today

```
llm.txt                       The contract for consuming coding agents. Start here
                              to see what VDD asks of an agent.
docs/01-goal-storming.md      The core practice, fully written.
docs/08-compare.md            VDD vs TDD / BDD / SbE / SDD / vibe coding — including
                              an honest account of what's new here vs inherited.
gherkin-guidelines.md         Writing the Validation layer. Forked from AutomationPanda (MIT).
evaluation-guidelines.md      Writing the Evaluation layer + ancillary verification
                              files (the four-questions contract, @verify-detail).
templates/                    Copy-into-your-project scaffolds: SPEC, CLAUDE/AGENTS,
                              Goal Storming worksheet, units/[name]/ skeleton.
examples/password-reset/      Worked example — pure Validation.
examples/dispute-summary/     Worked example — Validation + Evaluation.
skills/                       The authoring-side skill family, all five built:
                              vdd-bootstrap, goal-storming-facilitator,
                              gherkin-review, rubric-review, derivability-review.
units/gherkin-review/         The first dogfood unit — VDD building its own skill,
                              with field notes on everything that bent.
PROJECT_BRIEF.md / HANDOFF.md Historical snapshot / continuation brief.
LICENSING.md                  Dual license: Apache-2.0 (code) / CC BY 4.0 (docs).
```

**Built but not yet field-proven:** only `gherkin-review` has been through the
VDD loop itself; the other four skills are authored, consistent, and untested
by a real session. **Still to come:** an end-to-end pilot (the whole flow on a
real project — the flagship claim has never been tested), `docs/02`–`07`, and
`METHODOLOGY.md` (deliberately last). See [`skills/README.md`](skills/README.md).

## Getting oriented

1. Read [`llm.txt`](llm.txt) — the whole handoff in one page.
2. Read [`docs/01-goal-storming.md`](docs/01-goal-storming.md) — the practice
   that produces the standard.
3. Skim a worked example, then copy from [`templates/`](templates/).
4. Run a real feature through it and see where it breaks — that's the point.

## License

Dual-licensed: code, templates, and skills under **Apache-2.0**; methodology and
docs under **CC BY 4.0**; the forked [`gherkin-guidelines.md`](gherkin-guidelines.md)
stays **MIT**. Details in [`LICENSING.md`](LICENSING.md).

---

*This README describes a young, still-forming standard. If it reads more certain
than it should, that's the flaw described above — push on it.*
