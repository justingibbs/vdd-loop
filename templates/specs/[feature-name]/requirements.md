<!--
  requirements.md — TEMPLATE (agent-generated in practice).

  Copy the whole [feature-name]/ folder to specs/<feature>/ and rename. This is the
  agent's interpretation of the .feature (+ .rubric.md) files plus inherited SPEC.md
  constraints. It's scaffolding, not source of truth — if it disagrees with the
  .feature file, the .feature file wins.

  Delete these comments once filled in.
-->

# requirements.md — [feature-name]

> *[Design Concept (🟪) for this feature — the one-breath framing. Feature-scoped
> Design Concept cards land here, at the top of requirements.]*

## Goal (🟩)

[The one-line goal this feature proves. Every requirement below should trace to it;
one that doesn't is scope creep.]

## Scope

- **In scope:** [what this feature covers]
- **Out of scope:** [what it deliberately doesn't]

## Constraints inherited from SPEC.md (⬛)

- [constraint the implementation must respect]

## Requirements

<!-- Each requirement names the verification that backs it. The aim is that every
     requirement is verified; where a verification can't be found yet, mark it a
     known gap, not a blocker. -->

| # | Requirement | Verified by |
|---|-------------|-------------|
| R1 | [what must be true] | `.feature`: *[scenario]* or rubric **E?** |
| R2 | [what must be true] | [verification] |

## Non-goals

- [something a reader might expect that this feature explicitly does not do]

## Open questions

- [anything unresolved the loop surfaced; note if it blocks progress]
