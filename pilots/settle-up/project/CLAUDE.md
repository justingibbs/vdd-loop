# CLAUDE.md — settle-up

How we work in this repo. Always-active context — read this every session
before touching code or verification artifacts.

## The method: VDD

This project uses **Verification-Driven Development**. Read **`llm.txt`** for
the full contract; the short version:

- The unit of work lives in `units/settle-up/`: `settle-up.goals` (why) and
  `settle-up.feature` (the verification standard — the source of truth that
  tells you when you're done).
- Build however you judge best; your working docs belong in the unit folder.
- Validations pass only via executed checks (`behave`, real assertions —
  never by inspection). Loop until green, bounded; if the same failures
  survive an iteration unchanged, stop and report.
- **Never weaken the standard to pass.** `.feature` and `.goals` are
  read-only. If the standard looks wrong, say so and stop.

## SPEC.md is protected

**Never edit `SPEC.md` without explicit human approval.** If satisfying the
standard requires changing a constraint, write
`units/settle-up/schema-change-proposal.md` and pause for human review.

## Tooling and conventions

- **Language / runtime:** Python 3.11+ — standard library only for the tool.
- **BDD runner:** `behave`. Create `.venv` and `pip install behave` there
  (dev-only dependency). Step implementations may live in
  `units/settle-up/steps/` (the `.feature` itself stays untouched) or under a
  `features/` tree — your call; the standard file is read-only either way.
- **Entry point:** `python3 -m settle <ledger.csv>` per the SPEC CLI contract.
- **Never add runtime dependencies.**

## Where things live

- `SPEC.md` — constraints and the CLI/data contracts. Versioned & protected.
- `units/settle-up/` — the standard (`settle-up.goals`, `settle-up.feature`)
  plus whatever working docs you generate.
- `gherkin-guidelines.md` / `evaluation-guidelines.md` — authoring guides for
  the standard; consult only if asked to review or draft verifications.
