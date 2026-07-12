# 01 — Goal Storming

*The named collaborative practice at the heart of VDD. This document is the full facilitation guide: what it is, who's in the room, the cards, how to run a session start to finish, and where the output goes.*

---

## In one sentence

**Goal Storming is a structured session that starts with goals — "what does success actually mean here?" — and derives verification standards, and optionally a shared concept and a constraint spec, directly from those goals.**

It is the human-owned (now human-*and*-LLM) front of the VDD loop. Everything the agent later builds is downstream of what happens in this session.

---

## Where it sits in the flow

```
EVENT STORMING        (optional — only for new or unfamiliar domains)
      ↓
GOAL STORMING         ← you are here
      ↓
CODING AGENT          (usually a clean session, likely not the LLM that
                       was in this room — reads the standard and builds,
                       looping until the verifications pass; its working
                       docs, loop, and reporting are its own — see llm.txt)
```

Goal Storming runs at any scale — a whole project, a large chunk of work, a single feature. The same cards and sequence apply regardless.

**The artifact in all cases is a `units/[name]/` folder** — one folder per unit of work, named after the work (like a branch name: `initial-build`, `password-reset`); a project build-out may hold feature subfolders. The folder holds `[name].goals`, one or more `.feature` files, any ancillary verification files, and whatever working docs the coding agent later generates. What changes across scale is the *rigor of verification*: at project scale, verification intent can be prose; at feature scale, it must be executable Gherkin and `@eval` lines a runner can actually check. The verifications harden as you descend — but the practice is the same at every level.

---

## Why goals come first

A user story already presumes someone decided what mattered. Goal Storming starts one level up: **what does success mean here, before we assume the shape of the solution?**

Validations, Evaluations, Design Concepts, and Constraints are all *derived* from goals — they are different questions asked about the same underlying goal:

- "What, concretely, proves we hit this goal — that a deterministic check can confirm?" → **Validation**
- "What, about hitting this goal, requires judgment to assess?" → **Evaluation**
- "What must any solution respect, regardless of approach?" → **Constraint**
- "Can we say, in a breath, what this thing *is*?" → **Design Concept**

If the goals are wrong, perfectly correct verifications just prove the wrong thing very precisely. **Getting the goals right is the most important — and most human — part of the session.**

---

## Who is in the room

Humans own the goals. But the session is **not** human-only.

> **Revision from the original brief.** An earlier framing said Goal Storming was "human-only, agent not present," and cast any LLM role as a note-taker/drafter. That is intentionally overridden here: **an LLM joins the session as a participant.**

The LLM plays a **flexible role** — it can operate as either or both of:

- **Peer participant** — proposes its own cards, offers goals the humans haven't voiced, drafts candidate validations and design concepts, and argues for them.
- **Facilitator / challenger** — asks the sharpening questions, surfaces gaps ("goal 2 has no validation attached"), flags vague or unfalsifiable cards, and keeps the session moving through the sequence.

> *Open point, deliberately left flexible:* whether a given team runs the LLM primarily as a peer, primarily as a facilitator, or fluidly as both is a per-team choice. This guide assumes the fluid case and notes where the two roles pull in different directions.

**What the LLM does not do:** decide what ultimately matters. The humans retain authority over the GREEN cards. The LLM can *propose* a goal; it cannot *ratify* one. This is the one hard line — everything else in the session is genuinely collaborative.

---

## The cards

Cards are the unit of the session. Each color answers a different question about the goals.

| Color | Card type | Answers | Required? | Feeds |
|--------|------------------------|-----------------------------------------------|------------------------|-----------------------------|
| 🟩 GREEN | **Goals** | "What does success mean here?" | **Yes** — the spine | Referenced across all artifacts |
| 🟨 YELLOW | **Validations** | "What deterministic check proves this goal?" | **Yes** — ≥1 per goal | `.feature` |
| 🟦 BLUE | **Evaluations** | "What about this goal needs judgment to assess?"| When judgment is involved | `@eval` lines in `.feature` (+ optional `.rubric.md` detail) |
| 🟥 RED | **Negative validations** | "What must never happen?" | As needed | `.feature` |
| ⬛ BLACK | **Constraints** | "What must any solution respect, regardless?" | As needed | `SPEC.md` |
| 🟪 PURPLE | **Design Concepts** | "Can we say, in a breath, what this *is*?" | **Optional — but clarifying** | `SPEC.md` / `README.md` / `[name].goals` |

### 🟩 GREEN — Goals

The reason the work exists. Written as outcomes, not features. A good goal is something you could fail to achieve even with all the code written.

- Good: *"A user who forgot their password can get back into their account without contacting support."*
- Weak: *"Add a password reset endpoint."* (That's a task, not a goal — it presumes the solution.)

Every other card should trace back to at least one goal. If a card doesn't serve a goal, either you're missing a goal or the card is scope creep.

### 🟨 YELLOW — Validations

Deterministic, binary, machine-checkable outcomes that prove a goal is met. These become Gherkin scenarios in a `.feature` file.

- *"Given a valid reset token, when the user submits a new password, then they can log in with it."*

If you can write an assertion for it, it's a validation.

### 🟦 BLUE — Evaluations

Outcomes that require judgment — no single correct answer. Summarization quality, tone, relevance, classification quality. These become `@eval` lines in the `.feature` file — one line per criterion, inline with the Validation scenarios. When a criterion needs anchor descriptions or a multi-case evaluation set beyond what fits in a line, an optional `.rubric.md` detail file is linked via `@eval-detail`.

- *"The dispute summary captures the customer's core complaint without editorializing."* — scored, not asserted.

Reach for BLUE only when a YELLOW card genuinely can't capture the outcome. Most goals are fully served by validations.

### 🟥 RED — Negative validations

The things that must **never** happen. Deterministic like YELLOW, but framed as prohibitions. They land in the same `.feature` file as guard scenarios.

- *"An expired reset token must never grant access."*

RED cards are where security, safety, and data-integrity requirements live.

### ⬛ BLACK — Constraints

What any solution must respect regardless of approach: architecture decisions, compliance boundaries, tooling limits, non-functional requirements. These are the residue that becomes `SPEC.md` — the constraint surface.

- *"Must use the existing Postgres user store; no new datastore."*
- *"Reset tokens expire within 15 minutes (compliance)."*

BLACK cards are *constraints*, not designs. "Must run on Postgres" is a constraint; "here's the schema" is a design the agent derives.

### 🟪 PURPLE — Design Concepts

Optional, and often the most clarifying card on the board. A Design Concept is an attempt to **conceptualize the thing in a breath** — the project, a part of it, or a feature. It is a communication device, not a verification.

- *"A self-service back door that's safe because it's time-boxed and single-use."*

Its real value is diagnostic: **if the group (humans and LLM together) can't produce a crisp Design Concept, the goals usually aren't settled yet.** An easy, resonant concept is a signal of alignment; a struggle to write one is a signal to go back to the GREEN cards. Not required — but when it comes, keep it.

---

## Running a session

A session moves through the cards roughly in this order. It is **iterative, not linear** — expect to loop back, especially between GREEN and YELLOW/BLUE.

### 0. Frame the scope

State plainly whether this is a **project** or a **feature** session, and for a feature session, name the project constraints it inherits. This decides where the output lands (see below).

### 1. Surface the goals (GREEN)

Ask the room — humans and LLM — *"What does success mean here?"* Put up goal cards. Merge duplicates, split compound goals, and cut anything that's really a task in disguise. **Don't move on until the humans agree the GREEN cards are right.** This is the gate.

### 2. Derive verifications, one goal at a time (YELLOW → BLUE)

Take each goal and ask: *"What, concretely, would prove we hit this?"* **This push is the heart of the session** — reach past the obvious, and try to find a verification even for the fuzzy goals. A verification can be any form that credibly proves the goal (a deterministic check, a scored rubric, or something creative — see the note below); the two card colors are just the two most common shapes.

- If a deterministic check can confirm it → **YELLOW**.
- If it needs judgment → **BLUE**.
- If neither fits, invent the form that would — capture it and route it to whichever layer it resembles.

Attach each verification to the goal it serves. But **don't let a missing verification stop the session.** A goal you couldn't yet verify is a **known gap to revisit**, not a blocked goal — mark it and move on. The aim is to genuinely try; it's a journey toward a new way of building, not a checklist to complete. A goal verified partly beats a goal no one tried to verify.

> **On the form of a verification.** YELLOW and BLUE are the two common shapes — a deterministic check and a scored rubric — but a verification is *whatever credibly proves the goal.* A round-trip reconstruction, an adversarial probe, a comparison against a reference, a human spot-check, or something no one's tried yet are all fair game; capture the creative ones and route them to whichever layer they most resemble. The one quality to strive for, whatever the form: **it should be able to fail.** A verification that can't tell a good result from a bad one proves nothing. (For the Evaluation side, `evaluation-guidelines.md` documents the common toolkit and leaves the door open for invention.)

### 3. Add the guardrails (RED)

For each goal (and especially anything touching security, money, or data), ask: *"What must never happen?"* Put up RED cards.

### 4. Capture the constraints (BLACK)

Ask: *"What must any solution respect, no matter how we build it?"* Architecture, compliance, tooling, NFRs. Resist the urge to design — capture only the boundary, not the solution inside it.

### 5. Try the concept (PURPLE) — optional

Now that the goals and their verifications are on the board, attempt a Design Concept: *"Can we say, in a breath, what this is?"* Draft a few candidates (this is a great place to let the LLM riff), then pick or refine toward the one that's both **succinct and enticing**. If it won't come, note that and consider revisiting the goals.

### 6. Read the board back

Have someone — often the LLM — read the whole board as a narrative: "The goal is X; we'll know we hit it when Y and Z; it must never W; within constraints C; and the whole thing is, in a breath, P." If that story doesn't hang together, you're not done.

### Exit criteria

The session is done when:

- [ ] Every GREEN goal is agreed by the humans.
- [ ] Every goal has been *pushed on* for a verification — and either carries one, or is explicitly marked as a known gap to revisit. (Unverified goals are allowed; unexamined ones aren't.)
- [ ] Known prohibitions are on RED cards.
- [ ] Known constraints are on BLACK cards.
- [ ] (Optional) A Design Concept exists, or the group has consciously decided to proceed without one.

---

## Where the cards go

The board splits into artifacts. This mapping is what makes the output machine-consumable by the agent loop.

```
🟩 GREEN  Goals               → units/[name]/[name].goals
                                 (At project scale, goals also appear at the top
                                 of SPEC.md / README.md.)

🟨 YELLOW ┐
          ├ Validations        → units/[name]/[name].feature     (Validation layer)
🟥 RED    ┘ + Negative

🟦 BLUE   Evaluations          → # @eval lines in [name].feature (Evaluation layer)
                                  + optional units/[name]/[name].rubric.md
                                    (when criteria need anchor descriptions)

⬛ BLACK  Constraints          → SPEC.md                         (Constraint layer)

🟪 PURPLE Design Concepts      → units/[name]/[name].goals (its own section)
                                  (or SPEC.md / README.md at project scale)
```

Everything below the constraint layer — working docs, the implementation, and how
results are reported — is produced by the coding agent that consumes the standard
(usually in a clean session), in the same `units/[name]/` folder. VDD doesn't
prescribe those artifacts; `llm.txt` states the contract the agent honors while
producing them.

---

## Common failure modes

- **Tasks masquerading as goals.** "Add an endpoint" is not a goal. If it presumes the solution, it's below the goal line.
- **Not pushing for a verification.** The failure isn't leaving a goal unverified — that's an allowed gap. The failure is not *trying*: accepting a goal without asking "what would prove this?" Push first; if nothing fits yet, mark the gap and move on.
- **Reaching for BLUE too early.** If a deterministic check can capture it, use YELLOW. Evaluations are for genuine judgment, not for things that were merely awkward to assert.
- **Constraints written as designs.** BLACK cards are boundaries ("must use Postgres"), not schemas. Leave the inside of the boundary to the agent.
- **Forcing the concept.** If a Design Concept won't come, don't manufacture one — treat the difficulty as feedback about the goals.
- **Letting the LLM ratify goals.** The LLM proposes; humans decide what matters. Keep that line bright.

---

## A miniature example (feature scope)

> **Feature:** password reset.
>
> - 🟩 **Goal:** a user who forgot their password can regain access without contacting support.
> - 🟨 **Validation:** given a valid, unexpired token, submitting a new password lets the user log in with it.
> - 🟥 **Negative:** an expired or already-used token must never grant access.
> - ⬛ **Constraint:** tokens expire within 15 minutes; use the existing Postgres user store.
> - 🟪 **Design Concept:** *"a self-service back door that's safe because it's time-boxed and single-use."*
>
> Output: the YELLOW + RED cards become `units/password-reset/password-reset.feature`; the constraint reinforces `SPEC.md`; the goal and concept land in `units/password-reset/password-reset.goals`. No BLUE card — nothing here needs judgment, so no `@eval` lines.

The fuller worked version of this lives in `/examples/password-reset/`.

---

*This document defines the practice as currently understood. Goal Storming — and especially the LLM's role within it and the weight of the Design Concept card — is still being refined; treat this as the working standard, not the final word.*
