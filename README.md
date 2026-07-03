# vdd-loop

**Verification-Driven Development — a methodology and toolkit for building software with AI coding agents, where the human's primary job is defining what would prove the work correct, and the agent owns the rest inside a loop that runs until that standard is met.**

> TDD proved the code. BDD proved the behavior. VDD proves the loop.

---

> ⚠️ **Status: early and experimental.** This is a working sketch of a methodology, not a finished product. Much of what's here is still a document and an intention rather than running tooling. Names, cards, and file conventions are actively changing. Treat everything as a working draft, not a standard.

## The idea in a breath

Most agentic-coding guidance treats the **specification** as the primary artifact and verification as something you bolt on afterward. VDD inverts that:

```
What would prove this works?      ← Start here. The irreplaceable human judgment.
        ↓
What behavior does that imply?
        ↓
What architecture satisfies it?
        ↓
Agent builds it and loops until the verification standard passes.
```

A spec can be satisfied by the wrong implementation. A tight verification standard can't. An agent can derive a spec, a plan, and code from a precise-enough statement of *what would prove this correct* — but it can't invent that standard, because the standard is where the human says what actually matters.

The practice splits verification into two techniques:

- **Validation** — deterministic, binary, machine-checkable. Lives in `.feature` files (Gherkin).
- **Evaluation** — scored, judgment-based, checked by rubric or LLM-as-judge. Lives in `.rubric.md` files.

The human-owned front of the loop is a session called **Goal Storming** — start from goals ("what does success actually mean here?") and derive the verifications, constraints, and framing from them. See [`docs/01-goal-storming.md`](docs/01-goal-storming.md), which is the most developed piece of the methodology so far.

## Where it came from

VDD was inspired by **Lee Boonstra's** whitepaper, *["Spec-Driven Production Grade Development in the Age of Vibe Coding"](https://www.kaggle.com/whitepaper-spec-driven-production-grade-development-in-the-age-of-vibe-coding)* ([leeboonstra.dev](https://www.leeboonstra.dev/)). That paper makes the case for treating the spec as a first-class, production-grade artifact when you build with AI agents.

VDD is a response to that idea more than an implementation of it. The wager here is that the **verification standard**, not the spec, is the thing worth putting first — and that the spec, plan, and code are all better derived *from* verification than the other way around. If Boonstra's paper is "write the spec well," VDD's bet is "write down what would prove it, and let the spec fall out of that." Read the paper first; it's the clearer, more complete argument, and this repo is a riff on it.

## Provenance, and an honest caveat

Much of this repo was assembled **with the aid of an LLM** — the brief, the docs, the structure. That has an obvious upside and a real cost, and it's worth stating plainly:

The more I work with LLMs, the more impressed I am by them — and the more convinced I am that the **gestalt**, the actual crux of the message, still needs a human to clarify it. An LLM will happily produce a coherent, well-formatted, internally consistent methodology that is subtly *about the wrong thing*, or that reads as settled when it's really just fluent. The scaffolding here is fluent. Whether it's *right* is a separate question, and one that only gets answered by actually using it.

So: **this needs to be truly used to find its flaws.** The file conventions, the card colors, the claim that verification-first beats spec-first — none of that has been earned yet through real projects. Consider this an invitation to break it, not a spec to adopt. If you try it and it falls apart somewhere, that failure is the most valuable thing this repo can produce right now.

## What's actually here today

```
PROJECT_BRIEF.md              The original handoff / design brief. Snapshot of thinking.
docs/01-goal-storming.md      The core practice, fully written. Start here after the brief.
gherkin-guidelines.md         Writing the Validation layer (.feature). Forked from AutomationPanda (MIT).
evaluation-guidelines.md      Writing the Evaluation layer (.rubric.md). Written from scratch.
templates/                    Copy-into-your-project scaffolds: SPEC, CLAUDE/AGENTS, feature,
                              rubric, the Goal Storming worksheet, and the specs/ skeletons.
examples/password-reset/      Worked example — pure Validation (no rubric).
examples/dispute-summary/     Worked example — Validation + Evaluation (with a rubric).
LICENSING.md                  How the dual license splits across the repo.
LICENSE / LICENSE-docs        Apache-2.0 (code) / CC BY 4.0 (docs).
```

**Planned but not yet built** (see the repo structure in [`PROJECT_BRIEF.md`](PROJECT_BRIEF.md)): `METHODOLOGY.md`, the rest of `/docs` (`02`–`08`), and the agent `/skills` (bootstrap, feature-implement, verification-report, spec/gherkin/rubric review).

## Getting oriented

1. Read Boonstra's paper for the spec-driven argument VDD is reacting to.
2. Read [`PROJECT_BRIEF.md`](PROJECT_BRIEF.md) for the full intended shape and the open questions.
3. Read [`docs/01-goal-storming.md`](docs/01-goal-storming.md) for the one practice that's actually worked out.
4. Skim a worked example — [`examples/password-reset/`](examples/password-reset/) (pure Validation) or [`examples/dispute-summary/`](examples/dispute-summary/) (Validation + Evaluation) — to see the whole artifact chain end to end.
5. Copy from [`templates/`](templates/), leaning on [`gherkin-guidelines.md`](gherkin-guidelines.md) and [`evaluation-guidelines.md`](evaluation-guidelines.md) as you write the verifications.
6. Then — the point of the whole thing — try running a real feature through it and see where it breaks.

## License

`vdd-loop` is **dual-licensed**: code, templates, and skills under **Apache-2.0**; written methodology and docs under **CC BY 4.0**. The forked [`gherkin-guidelines.md`](gherkin-guidelines.md) stays under its upstream **MIT**. Full details and the file-by-file split are in [`LICENSING.md`](LICENSING.md).

---

*This README describes an early, still-forming methodology. If it reads as more certain than it should, that's exactly the flaw described above — push on it.*
