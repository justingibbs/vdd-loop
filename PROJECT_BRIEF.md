# PROJECT_BRIEF.md
## vdd-loop — Verification-Driven Development for Agentic Engineering

*Handoff document — written June 2026. Use this to scaffold the repo.*

---

## What This Project Is

**vdd-loop** is a methodology and toolkit for building software with AI coding agents, where the human's primary job is defining verification standards — not writing specs, not writing code — and the agent owns everything else inside a loop that runs until those standards are met.

It sits in the lineage of TDD and BDD, but is purpose-built for a world where an agent, not a human, implements the code:

> TDD proved the code. BDD proved the behavior. VDD proves the loop.

The core inversion from prior methodologies: **verification comes first**, not last. You don't write a spec and then figure out how to test it. You define what would prove the work correct, and everything else — the spec, the architecture, the implementation — is derived from that standard, mostly by the agent.

---

## The Naming

- **Practice name:** VDD — Verification-Driven Development
- **Repo name:** `vdd-loop`
- **Umbrella concept:** Verification (the thing that proves "done")
- **Two techniques under that umbrella:**
  - **Validation** — deterministic, binary, checked by code/assertions. Maps to `.feature` files (Gherkin).
  - **Evaluation** — scored, judgment-based, checked by LLM-as-judge or rubric. Maps to `.rubric.md` files.

---

## The Core Insight

Most agentic coding guidance (Spec-Driven Development, BDD-for-agents, etc.) treats the specification as primary and verification as a downstream concern — something you add once the spec exists. VDD inverts this:

```
What would prove this works?          ← Start here. This is the
        ↓                                irreplaceable human judgment.
What behavior does that imply?
        ↓
What architecture satisfies it?
        ↓
Agent builds it and loops until
the verification standard passes.
```

A specification can be satisfied by the wrong implementation. A tight verification standard cannot. The agent can derive a spec, a plan, and code from a sufficiently precise verification standard — but it cannot invent the standard itself, because the standard encodes what the human actually cares about.

---

## The Full Methodology Flow

```
EVENT STORMING  (optional — only for new or complex domains)
  Purpose: build shared understanding of the domain before
  you can meaningfully define what "success" looks like in it.
  Skip this step if the domain is already well understood
  by the team (e.g. adding a feature to a mature product).

        ↓

GOAL STORMING  (the named collaborative practice — replaces
                 "Verification Storming" and "Event Storming"
                 as the per-feature/per-project session)

  A structured session (human-only, agent not present) that
  starts with goals and derives verification artifacts from them.

  [SUPERSEDED — see docs/01-goal-storming.md] The "human-only,
  agent not present" framing has since been revised: an LLM now
  joins the session as a participant (peer and/or facilitator),
  while humans retain sole authority to ratify goals. The
  goal-storming doc is the current word; this brief is kept as a
  historical snapshot.

  Card types:
    GREEN  → Goals          "What does success mean here?"
    YELLOW → Validations    Deterministic, testable outcomes
    BLUE   → Evaluations    Judgment-based, scored outcomes
    RED    → Negative       "This must never happen"
             validations
    BLACK  → Constraints    Architecture, compliance, tooling
                             limits that apply regardless of
                             approach

  Output of the session splits three ways:
    YELLOW + RED cards  → .feature file        (Validation layer)
    BLUE cards          → .rubric.md file       (Evaluation layer)
    BLACK cards         → SPEC.md               (Constraint layer)

        ↓

AGENT LOOP
  Reads: .feature + .rubric.md + SPEC.md + CLAUDE.md + Skills
  Generates: requirements.md, plan.md, tasks.md, implementation,
             tests, verification-report.md — freely, as needed
  Validates: deterministically against .feature scenarios
  Evaluates: against .rubric.md criteria where judgment is required
  Loops until: both layers pass, OR a stop condition is hit
```

---

## Why Goals Come First in the Session

A user story already presumes someone decided what matters. Goal Storming starts one level up: what does success actually mean here, for this feature or this project? Validations, Evaluations, and Constraints are all *derived* from goals — they're answers to different questions about the same underlying goal:

- "What, concretely, proves we hit this goal, that a deterministic check can confirm?" → **Validation**
- "What, about hitting this goal, requires judgment to assess?" → **Evaluation**
- "What must any solution respect, regardless of approach?" → **Constraint**

If goals are wrong, perfectly correct verifications just prove the wrong thing very precisely. Getting the goals right is the most important — and most human — part of the session.

---

## The File Artifacts

### Per-project (set once, evolves rarely)

```
VISION.md or PRD.md   → Why the product exists. Who it serves.
                         Rarely touched. Product strategy.

SPEC.md               → What we're building overall.
                         Architecture, data model, API contracts,
                         ADRs, NFRs, out-of-scope.
                         VERSIONED (e.g. 1.0.0, incremented on
                         every change).
                         PROTECTED — agent must never edit without
                         explicit human approval. If a feature
                         requires a SPEC.md change, the agent writes
                         a schema-change-proposal.md and pauses.
                         Format: Markdown for narrative sections
                         (What We're Building, Architecture, ADRs,
                         NFRs); YAML for deeply nested structured
                         data (Data Model, API Contracts) — nesting
                         depth > 3 parses meaningfully better in
                         YAML than Markdown prose, JSON, or XML.

CLAUDE.md / AGENTS.md → How we work. Tooling, conventions, style.
                         Always active context, read every session.
                         Almost never changes.
                         Should include:
                           - Tooling rules (package manager,
                             test framework, naming conventions)
                           - SPEC.md protection rule
                           - Reference to gherkin-guidelines.md
                           - Reference to evaluation-guidelines.md
                             (our forked/adapted version)

gherkin-guidelines.md → Forked from AutomationPanda's
                         gherkin-guidelines-for-ai, adapted for
                         VDD's validation-first framing.
                         Referenced by CLAUDE.md so the agent
                         writes/reviews .feature files consistently.

evaluation-guidelines.md → New artifact, not currently standardized
                         elsewhere. Defines how to write a good
                         .rubric.md — what makes an evaluation
                         criterion well-formed (falsifiable,
                         scored on a defined scale, includes a
                         pass threshold).
```

### Per-feature (one set per user story / unit of work)

```
/features/
  [feature-name].feature      ← YOU (or the Goal Storming session)
                                 write this. Gherkin. The Validation
                                 layer. One file per user story.

/evaluations/
  [feature-name].rubric.md    ← Output of Goal Storming's BLUE cards.
                                 The Evaluation layer. Only needed
                                 when the feature involves judgment-
                                 based outcomes (summarization,
                                 tone, relevance, classification
                                 quality, etc.) — not every feature
                                 needs this file.

/specs/
  [feature-name]/
    requirements.md           ← Agent generates. Its interpretation
                                 of the .feature + .rubric.md files.
    plan.md                   ← Agent generates. Architecture for
                                 this feature specifically.
    tasks.md                  ← Agent generates and tracks. Atomic
                                 implementable units.
    verification-report.md    ← Verifier agent writes after each
                                 loop run. Reports pass/fail per
                                 scenario AND per evaluation
                                 criterion, with specifics on any
                                 failure: which scenario/criterion,
                                 what was attempted, what's needed.
    schema-change-proposal.md ← Only created if the agent determines
                                 a feature requires a SPEC.md change.
                                 Triggers a pause for human review.
    [anything else the agent
     finds useful]            ← Agent has full freedom here. This
                                 directory is scaffolding, not
                                 source of truth.
```

---

## Repo Structure To Scaffold

```
vdd-loop/
├── README.md                    ← What VDD is, why, quickstart
├── METHODOLOGY.md                ← The full practice document
│                                   (this brief, expanded/cleaned)
├── LICENSE
│
├── /docs/
│   ├── 01-goal-storming.md      ← The named practice, in full —
│   │                               how to run the session, card
│   │                               types, facilitation guide
│   ├── 02-event-storming-first.md ← When/why to do ES before
│   │                                 Goal Storming
│   ├── 03-validation-vs-evaluation.md ← The core distinction,
│   │                                     when to use which
│   ├── 04-feature-files.md      ← Writing a Validation standard
│   ├── 05-rubric-files.md       ← Writing an Evaluation standard
│   ├── 06-spec-md.md            ← Project spec as constraint
│   │                               surface, versioning, protection
│   ├── 07-agent-loop.md         ← Loop design surfaces (discovery,
│   │                               delegation, verification,
│   │                               persistence, scheduling)
│   └── 08-compare.md            ← vs BDD, TDD, SDD, vibe coding,
│                                    Palmer's loop engineering
│
├── /templates/                   ← Humans copy these into their
│   │                               own project
│   ├── SPEC.md
│   ├── CLAUDE.md
│   ├── AGENTS.md
│   ├── feature.feature
│   ├── rubric.md
│   ├── goal-storming-session.md ← Facilitation template — the
│   │                               questions to ask, card prompts,
│   │                               how to run the session start
│   │                               to finish
│   └── /specs/
│       └── [feature-name]/
│           ├── requirements.md
│           ├── plan.md
│           ├── tasks.md
│           └── verification-report.md
│
├── /skills/                      ← Executable agent skills.
│   │                               VDD's own SKILL.md format —
│   │                               not bound to Osmani's spec.
│   ├── /vdd-bootstrap/
│   │   └── SKILL.md             ← Scaffold a new VDD project
│   ├── /goal-storming-facilitator/
│   │   └── SKILL.md             ← Agent assists running a Goal
│   │                               Storming session. [SUPERSEDED —
│   │                               the LLM is now a session
│   │                               participant (peer/facilitator),
│   │                               not just a note-taker; see
│   │                               docs/01-goal-storming.md]
│   ├── /feature-implement/
│   │   └── SKILL.md             ← Core loop skill. Reads .feature
│   │                               + .rubric.md, generates working
│   │                               docs, implements, validates,
│   │                               evaluates, writes report.
│   ├── /spec-guardian/
│   │   └── SKILL.md             ← Watches SPEC.md. Blocks agent
│   │                               edits. Writes schema-change-
│   │                               proposal.md and pauses.
│   ├── /gherkin-review/
│   │   └── SKILL.md             ← Validates .feature files against
│   │                               gherkin-guidelines.md
│   ├── /rubric-review/
│   │   └── SKILL.md             ← Validates .rubric.md files
│   │                               against evaluation-guidelines.md
│   └── /verification-report/
│       └── SKILL.md             ← Verifier skill. Runs validation
│                                    + evaluation, writes structured
│                                    report.
│
├── /examples/                    ← Real worked examples
│   ├── /password-reset/         ← Pure Validation example
│   │   ├── password-reset.feature
│   │   └── /specs/password-reset/
│   │       ├── requirements.md
│   │       ├── plan.md
│   │       └── verification-report.md
│   │
│   └── /dispute-summary/        ← Validation + Evaluation example
│       │                           (judgment-based feature)
│       ├── dispute-summary.feature
│       ├── /evaluations/
│       │   └── dispute-summary.rubric.md
│       └── /specs/dispute-summary/
│           └── verification-report.md
│
├── /gherkin-guidelines.md        ← Forked from AutomationPanda,
│                                    adapted for VDD
└── /evaluation-guidelines.md     ← New — defines how to write a
                                     good rubric.md
```

---

## What Was Deliberately Left Out

**Harness / environment setup** (devcontainers, CI pipeline config, sandboxing) — explicitly excluded from this repo's scope. VDD operates at the context/specification/verification layer. How a team wires their execution environment, sandboxing, and CI is left to them — it's orthogonal to the methodology and varies too much by team/stack to standardize here.

---

## Design Decisions Already Made

1. **Validation vs Evaluation is a first-class distinction**, not folded into a single acronym. Validation = deterministic (`.feature`). Evaluation = scored/judgment-based (`.rubric.md`). Most features only need Validation. Evaluation is reached for when a feature involves summarization, tone, classification quality, or any output without a single correct answer.

2. **SPEC.md is versioned and protected.** Increment version on every change. Agent must never edit without explicit human approval — this rule lives in CLAUDE.md. SPEC.md is treated as the residue of Goal Storming's BLACK cards, not a document written upfront from imagination.

3. **One `.feature` file per user story.** Contains all scenarios for that story — happy path, failure cases, edge cases.

4. **Agents have full freedom inside `/specs/[feature-name]/`.** This is scaffolding, not source of truth. Verifier agents are explicitly encouraged to write their own assessment documents (e.g. `verification-report.md`) freely.

5. **`gherkin-guidelines.md` is forked from AutomationPanda's `gherkin-guidelines-for-ai`**, not just referenced — because VDD's framing of Gherkin as a verification standard (not just a spec format) warrants its own adapted guidance.

6. **Skills use VDD's own format**, not bound to Addy Osmani's `agent-skills` SKILL.md spec, to allow the format to evolve with the methodology rather than tracking an external standard.

7. **No harness/environment layer in this repo.** Stays scoped to context, verification, and the loop.

8. **Primary audience is individual developers, built to scale to teams.** The repo should work for a solo developer adopting this on a side project, but the file structure and naming conventions should hold up when multiple people (and multiple agents) are working across many features over time — to the point that an LLM should be able to read a project's accumulated `.feature`, `.rubric.md`, and `SPEC.md` files and accurately summarize what the project does and generate a diagram of it, without additional onboarding documentation. This is a deliberate test of whether the methodology's artifacts are self-describing.

---

## Open Questions Still To Resolve

- [ ] Does Goal Storming fully replace the separate "Verification Storming" concept discussed earlier, or do we keep both as named sub-steps?
- [ ] What does the `goal-storming-facilitator` skill actually do — strictly transcribe/organize a live human session, or can it run a Goal Storming session solo with a single stakeholder via structured Q&A?
- [ ] Should `.rubric.md` support multiple criteria with different scoring scales (0-5 vs pass/fail) within the same file, or should each criterion be its own file?
- [ ] What's the actual mechanism for "ask the LLM to summarize this project and build a diagram" — is that a skill in this repo (`/skills/project-summarize/`) or left as a generic capability any agent should be able to do given the file structure?
- [ ] Final repo name — `vdd-loop` is the current working name.

---

## Immediate Next Steps (in Cowork or Claude Code)

1. Initialize git repo, add README.md and LICENSE
2. Build `/templates/SPEC.md`, `/templates/CLAUDE.md`, `/templates/feature.feature` first — these unblock everything else
3. Write `/docs/01-goal-storming.md` — this is the most novel and important piece of the methodology, get it right before building skills around it
4. Build `/skills/feature-implement/SKILL.md` — the core loop skill
5. Build out `/examples/password-reset/` as the canonical worked example
6. Fork and adapt `gherkin-guidelines.md`
7. Write `evaluation-guidelines.md` from scratch — no existing standard to fork

---

*This brief reflects the state of thinking as of the conversation it was generated from. Treat it as a snapshot to build from, not a final spec — the methodology itself is still being refined.*
