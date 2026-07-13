# HANDOFF.md — Continuation Brief

*For the next agent (LLM or human) picking up `vdd-loop`. This is the "where we are, what's next" snapshot. Written 2026-07-02; **updated 2026-07-12** (first dogfood run + the scope simplification, §3.9–§3.12). Unlike `PROJECT_BRIEF.md` (the original design snapshot), this file tracks **current state and live decisions** — when the two disagree, this file and the docs it points to are newer.*

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
| **Templates** | `templates/` (SPEC, CLAUDE, AGENTS, goal-storming-session, + `units/[name]/` skeletons: `.goals`, `.feature`, `.rubric.md`) | ✅ Copy-in scaffolds (working-doc templates removed per §3.9). |
| **Contract** | `llm.txt` | ✅ The consuming-agent contract (added 2026-07-12). |
| **Skill family** | `skills/` — bootstrap, facilitator, gherkin-review, rubric-review, derivability-review | ✅ All five built 2026-07-12; only `gherkin-review` dogfooded. |
| **Compare doc** | `docs/08-compare.md` | ✅ Written 2026-07-12; honest new-vs-inherited accounting. |
| **First dogfood** | `units/gherkin-review/` | ✅ Run 1 PASS (9/9 validation, mechanical); field notes FN-1–FN-11. |
| **End-to-end pilot** | `pilots/settle-up/` | ✅ PASS 2026-07-12: probe (8 risky gaps) → SPEC 1.1.0 → cold build 8/8 in 1 iteration → audit clean. Field notes FN-P1–P6. |
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

*Added 2026-07-12, after the first dogfood run (`units/gherkin-review/` — read its `field-notes.md`):*

9. **VDD is authoring-side only.** The biggest scope decision since the brief. VDD is a *standard* — files (`.goals`, `.feature`, ancillary verification docs, `spec.md`), a loose folder structure, and skills that **write, grade, and push on** verifications. The build loop, runner, working docs, and report format belong to the consuming coding agent (usually a clean session). The retired `feature-implement` and `verification-report` skills' invariants survive as **`llm.txt`** — the contract handed to any consuming agent. Do not rebuild loop-execution skills inside VDD.
10. **`.goals` is a first-class extension.** `goals.md` → `units/<name>/<name>.goals`, parallel to `<name>.feature`. The Design Concept lives in its section of the `.goals` file (no more `requirements.md` destination — that file is now the coding agent's business, if it even makes one).
11. **The layer is defined by the check, not the checked** (owner's ruling, first dogfood). A mechanical assertion over LLM-produced output is Validation; subject variance is a protocol concern. Now stated in `gherkin-guidelines.md`'s layer-boundary section.
12. **`derivability-review` joined the roster** — the "does this standard carry enough context (and low enough variance) for a cold session to build the right thing?" check. Arguably VDD's most distinctive skill; not yet built.
13. **Ancillary verification files: contract, not formats.** Any shape is allowed, but every ancillary file must answer four questions (what it verifies / on what inputs / by what method and executor / what counts as pass), and the `.feature` must declare each one via a `# @verify-detail | <path> | <what it provides>` header line (generalizing `@eval-detail`). Specific formats are *earned* — documented only after recurring in real units (`.rubric.md` is the only earned shape so far; evaluation sets are the likely next). Canonical in `evaluation-guidelines.md` § Ancillary verification files.

---

## 4. What's next — not yet built (prioritized)

*(Rewritten a third time on 2026-07-12: the end-to-end pilot has now RUN and
PASSED — see `pilots/settle-up/`. The flagship claim held: derivability probe
found 8 risky gaps → standard tightened → cold builder went green in one
iteration → independent audit clean. `derivability-review` ran split-session
inside the pilot, closing the old items 1–2.)*

1. **Independent re-score of the dogfood's Evaluation layer.** `units/gherkin-review/verification-report.md` is self-scored (FN-5); a fresh session (or the owner) should re-judge E1–E3 from `runs/*.findings.md` cold. Small, and the last unproven claim from run 1.
2. **Fold the pilot's friction back into the docs** (FN-P3): an `llm.txt` line about verifying `standard.checksums` when present; authoring guidance on stating an oracle's independence boundary; decide whether to pin an error-reason grammar.
3. **A failure-mode pilot** (FN-P2): hand off a deliberately under-tightened standard and observe the loop's PAUSE/stuck states, which two green-first-try runs have never exercised. Also still unexercised: `rubric-review` in anger, live-group facilitation, an `@eval`-bearing build.
4. **Formally close the stale open questions** (§5.1, §5.4, §5.5) — one small edit each.
5. **`METHODOLOGY.md` and `/docs/02`–`07`** — now backed by two runs of real evidence; still best written after the failure-mode pilot rounds out the picture.

---

## 5. Open questions still to resolve

Carried from the brief, with status updated:

1. Does Goal Storming fully replace the separate "Verification Storming" concept? — *Still open; the brief treats it as replaced, no one has pushed back.*
2. What does `goal-storming-facilitator` actually do — transcribe a live human session, or run one solo with a single stakeholder via structured Q&A? — ✅ **Resolved 2026-07-12: both.** The skill is dual-mode, chosen at step 0 (live group facilitation, or solo structured Q&A). The solo mode has live evidence — the two Goal Storming sessions that produced the `gherkin-review` unit and the ancillary-files decision were effectively solo runs. *Owner may veto; decided while building rather than asked.*
3. Should `.rubric.md` support multiple criteria with different scales in one file? — ✅ **Resolved: yes** (§3.6).
4. What's the mechanism for "ask an LLM to summarize this project and build a diagram" — a dedicated skill or a generic capability? — *Probably subsumed (2026-07-12): `llm.txt` + the standard files are the onboarding, and `derivability-review`'s "cold reading" section is literally an LLM summarizing the project from its artifacts. Recommend closing as "generic capability, tested by derivability-review" — owner to confirm.*
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
- **Commit message convention:** end with a `Co-Authored-By:` line naming the model that did the work (e.g. `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`).
- **Untracked files may appear** that the owner added out-of-band (this session: the `LICENSE*` files, `README.md`, brief edits). Review before committing; don't sweep unknown files into an unrelated commit.

---

## 7. Git facts

- **Remote:** `git@github.com:justingibbs/vdd-loop.git` (SSH). **Branch:** `main` (tracks `origin/main`).
- **Latest commit at handoff:** `c64df59 Annotate superseded human-only framing in brief`.
- Working tree was clean at the time this file was written (before committing this file itself).

---

*The first dogfood run happened (2026-07-12, `units/gherkin-review/`) and did exactly what the README promised: it found where the methodology bent, and the scope was cut back accordingly. The highest-value thing remains the same — keep running real work through it, preferably with the standard's author and the builder in separate sessions, and keep the field notes honest.*
