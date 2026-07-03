# HANDOFF.md — Continuation Brief

*For the next agent (LLM or human) picking up `vdd-loop`. This is the "where we are, what's next" snapshot. Written 2026-07-02. Unlike `PROJECT_BRIEF.md` (the original design snapshot), this file tracks **current state and live decisions** — when the two disagree, this file and the docs it points to are newer.*

---

## 0. How to use this file

1. Read `README.md` for what VDD is and the honest "still experimental" framing.
2. Read `PROJECT_BRIEF.md` for the full intended shape — but note it's a **historical snapshot**; several parts are explicitly `[SUPERSEDED]` (see §3).
3. Read `docs/01-goal-storming.md` — the most developed piece and the **current word** wherever it conflicts with the brief.
4. Then use this file to see what's built, what's decided, and what to do next.

**Prime directive for continuing:** don't silently revert the decisions in §3. They were made deliberately this session, in dialogue with the repo owner, and they evolve past the original brief. If you think one is wrong, raise it — don't just undo it.

---

## 1. What VDD is (one paragraph)

Verification-Driven Development: the human's primary job is defining **what would prove the work correct**; the agent derives the spec, plan, and code from that standard and loops until it passes. Verification splits into two techniques — **Validation** (deterministic, binary → `.feature` files) and **Evaluation** (scored, judgment-based → `.rubric.md` files). The human-owned front of the loop is a session called **Goal Storming**.

---

## 2. Current state — what's built

All committed and pushed to `origin/main` (`git@github.com:justingibbs/vdd-loop.git`).

| Area | Files | State |
|------|-------|-------|
| **Core practice** | `docs/01-goal-storming.md` | ✅ Complete. Card types, LLM-as-participant, session flow, card→artifact mapping. |
| **Guidelines pair** | `gherkin-guidelines.md` (Validation), `evaluation-guidelines.md` (Evaluation) | ✅ Complete. Sibling guides — one per technique. |
| **Worked example (Validation only)** | `examples/password-reset/` | ✅ `.feature` + requirements/plan/tasks/verification-report. No rubric (by design). |
| **Worked example (Validation + Evaluation)** | `examples/dispute-summary/` | ✅ `.feature` + `.rubric.md` + requirements/verification-report. |
| **Templates** | `templates/` (SPEC, CLAUDE, AGENTS, feature, rubric, goal-storming-session, + `specs/[feature-name]/` skeletons) | ✅ Complete copy-in scaffolds. |
| **Licensing** | `LICENSE` (Apache-2.0), `LICENSE-docs` (CC BY 4.0), `LICENSING.md` | ✅ Dual-license scheme. |
| **Front door** | `README.md` | ✅ Status sections current as of this handoff. |
| **Original brief** | `PROJECT_BRIEF.md` | ✅ Kept as a historical snapshot; partially annotated `[SUPERSEDED]`. |

---

## 3. Decisions made this session (evolve past the brief — do not revert)

1. **LLM joins Goal Storming as a participant.** Overrides the brief's "human-only, agent not present." The LLM is a flexible peer/facilitator; **humans retain sole authority to ratify goals** (the LLM proposes, never ratifies). Canonical in `docs/01-goal-storming.md`; brief annotated `[SUPERSEDED]`.
2. **Design Concept is a card (🟪 PURPLE).** Optional, and primarily *diagnostic* — if the group can't state a crisp one-breath concept, the goals probably aren't settled. Endpoint is scope-dependent: project session → `SPEC.md`/`README.md`; feature session → that feature's `requirements.md`.
3. **Verification guidance is a TOOLKIT, not a mandate.** The biggest reframe (commit `60e5de6`). A verification is *whatever credibly proves the goal* — scored scales, gates, judge protocols, eval sets are common patterns, not requirements. Invent creative forms (round-trip, adversarial probe, pairwise, human spot-check) when they fit better.
4. **Push, but don't block.** The exercise is genuinely trying to answer "what would prove this?" for every goal. But a goal with **no verification is an allowed known-gap to revisit**, not a blocker. The failure is *not trying*, not the gap. This deliberately softened earlier "a goal with no verification is a wish" hard-line language across the docs, rubric example, and requirements.
5. **Falsifiability is a north star, not a gate.** When you *do* write a verification, strive to make it *able to fail* — a verification that can't tell good from bad proves nothing. Aspiration, not a compliance check.
6. **Rubric structure: one file per feature, multiple criteria, mixed scales.** 0–5 for graded qualities; PASS/FAIL **gates** (not averaged) for hard lines. This resolved one of the brief's open questions.
7. **`CLAUDE.md` is canonical; `AGENTS.md` is a thin pointer** to it (avoids drift). The `AGENTS.md` template documents how to invert this if a toolchain reads only `AGENTS.md`.
8. **`gherkin-guidelines.md` is a fork of AutomationPanda's `gherkin-guidelines-for-ai`** (MIT, © 2026 Pandy Knight). The MIT license + copyright notice are preserved in-file and **must stay** — `LICENSING.md` commits to it. Adaptations (verification-first framing, YELLOW/RED mapping, Evaluation-boundary section, traceability header) are under the same MIT.

---

## 4. What's next — not yet built (prioritized)

The README's "planned but not yet built": `METHODOLOGY.md`, `/docs/02`–`08`, and `/skills/*`.

**Recommended order and rationale:**

1. **`/skills/feature-implement/SKILL.md` — highest value.** This is the core loop skill (reads `.feature` + `.rubric.md` + `SPEC.md`, generates working docs, implements, validates, evaluates, writes the report). It's what turns the repo from *documentation* into something *executable*. Everything needed to write it now exists (both guidelines, both examples, templates). Note: VDD uses its **own SKILL.md format**, not bound to Addy Osmani's spec (brief design decision #6) — so part of this task is deciding that format.
2. **`/skills/vdd-bootstrap/SKILL.md`** — scaffolds a new VDD project from the templates. High leverage, low novelty (mostly copies `templates/`).
3. **The review skills** — `gherkin-review`, `rubric-review` (validate `.feature`/`.rubric.md` against the two guidelines), `spec-guardian` (enforces the SPEC.md protection rule), `verification-report` (the verifier).
4. **`/docs/02`–`08`** — the rest of the doc set (event-storming-first, validation-vs-evaluation, feature-files, rubric-files, spec-md, agent-loop, compare). Lower urgency; `01` already carries the core.
5. **`METHODOLOGY.md`** — the full practice document (the brief, expanded/cleaned). Best written *last*, once the pieces have settled.
6. **`/skills/goal-storming-facilitator/SKILL.md`** — depends on resolving open question §5.2 (does it transcribe a live session, or run one solo via structured Q&A?).

---

## 5. Open questions still to resolve

Carried from the brief, with status updated:

1. Does Goal Storming fully replace the separate "Verification Storming" concept? — *Still open; the brief treats it as replaced, no one has pushed back.*
2. What does `goal-storming-facilitator` actually do — transcribe a live human session, or run one solo with a single stakeholder via structured Q&A? — *Still open. Partially informed by the LLM-as-participant decision (§3.1), but the solo-run mode isn't settled.*
3. Should `.rubric.md` support multiple criteria with different scales in one file? — ✅ **Resolved: yes** (§3.6).
4. What's the mechanism for "ask an LLM to summarize this project and build a diagram" — a dedicated skill or a generic capability? — *Still open. Note: brief design decision #8 makes this a deliberate test of whether the artifacts are self-describing.*
5. Final repo name — `vdd-loop` is the working name. — *Effectively settled in practice (README, remote, all docs use it), but never formally closed.*

New, surfaced this session:
6. **What is VDD's own SKILL.md format?** Design decision #6 says it's not bound to Osmani's spec — but no format has been defined yet. The first skill built (`feature-implement`) will force this decision.
7. **Where do 🟩 GREEN goals live as a file artifact?** Current convention (chosen this session): a short goals list atop the target artifact (`requirements.md` for a feature, `SPEC.md`/`README.md` for a project). Not given a dedicated file. Revisit if it proves insufficient.

---

## 6. Guardrails & conventions for whoever continues

- **`SPEC.md` is protected.** Never edit a project's `SPEC.md` without explicit human approval. If a feature needs a SPEC change, write `specs/<feature>/schema-change-proposal.md` and pause. (This rule is in the CLAUDE.md template.)
- **Keep the two license notices intact** — the MIT block in `gherkin-guidelines.md` and the dual-license split in `LICENSING.md`. If you add a new "meant to be read" doc, it's CC BY 4.0 by the rule of thumb; add it to the `LICENSING.md` table.
- **The methodology is living.** Docs say so about themselves. Treat `docs/01-goal-storming.md` and the guidelines as the current word; the brief as history.
- **Internal consistency is the product.** Design decision #8: an LLM should be able to read the accumulated artifacts and accurately describe the project. When you add or change something, keep the cross-references true (examples ↔ guidelines ↔ templates ↔ docs). This session repeatedly fixed dangling references — don't reintroduce them.

### Working with the repo owner (process notes)

- **Consult before building on conceptual/design decisions.** The owner prefers to shape naming, card types, and framing *in dialogue* before code is written. Several good pivots this session came from that (Design Concept as a card; toolkit-not-mandate; push-don't-block). Ask; don't assume.
- **Commit/push cadence:** commit when the owner asks; push when the owner asks. Don't push unprompted.
- **Commit message convention:** end with `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`.
- **Untracked files may appear** that the owner added out-of-band (this session: the `LICENSE*` files, `README.md`, brief edits). Review before committing; don't sweep unknown files into an unrelated commit.

---

## 7. Git facts

- **Remote:** `git@github.com:justingibbs/vdd-loop.git` (SSH). **Branch:** `main` (tracks `origin/main`).
- **Latest commit at handoff:** `c64df59 Annotate superseded human-only framing in brief`.
- Working tree was clean at the time this file was written (before committing this file itself).

---

*The single most valuable next step is `/skills/feature-implement/` — it's what makes VDD runnable instead of just readable. But per README's own caveat: the highest-value thing overall is to run a real feature through this and find where it breaks.*
