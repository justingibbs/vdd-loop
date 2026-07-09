<!--
  requirements.md — TEMPLATE (agent-generated in practice).

  The agent's interpretation of [name].feature (Validation scenarios + @eval
  Evaluation criteria) plus inherited SPEC.md constraints. Scaffolding, not source
  of truth — if this disagrees with the .feature file, the .feature file wins.

  Delete these comments once filled in.
-->

# requirements.md — [unit-name]

> *[Design Concept (🟪) for this unit — the one-breath framing. Lands here, at
> the top of requirements, for unit-scope sessions.]*

## Goal (🟩)

[The one-line goal this unit proves. Every requirement below should trace to it;
one that doesn't is scope creep.]

## Scope

- **In scope:** [what this unit covers]
- **Out of scope:** [what it deliberately doesn't]

## Constraints inherited from SPEC.md (⬛)

- [constraint the implementation must respect]

## Requirements

<!-- Each requirement names the verification that backs it. Trace to a .feature
     scenario (Validation) or @eval criterion (Evaluation). Where a verification
     can't be found yet, mark it a known gap, not a blocker. -->

| # | Requirement | Verified by |
|---|-------------|-------------|
| R1 | [what must be true] | `.feature`: *[scenario title]* |
| R2 | [what must be true] | `@eval` **E?** ([criterion name]) |

## Non-goals

- [something a reader might expect that this unit explicitly does not do]

## Open questions

- [anything unresolved the loop surfaced; note if it blocks progress]
