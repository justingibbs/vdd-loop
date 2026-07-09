<!--
  plan.md — TEMPLATE (agent-generated in practice).

  The unit's architecture: how the code will satisfy the .feature scenarios and
  @eval criteria. Describes the shape of the solution, not a restatement of the
  requirements. Include only what's useful — a small unit may not need a plan at all.

  Delete these comments once filled in.
-->

# plan.md — [unit-name]

## Approach in a paragraph

[The solution in plain language: the key components, where data lives, the main
operations, and the one or two decisions that shape everything else.]

## Data model / interfaces touched

[New or changed tables, types, or contracts. Respect SPEC.md constraints — flag any
change that would require a schema-change-proposal.md and a pause.]

## Operations / components

### [Operation or component name]  → satisfies [R?]
1. [step]
2. [step]

## How each verification is satisfied

| Scenario / criterion | Mechanism |
|----------------------|-----------|
| [.feature scenario] | [how the design makes it pass] |
| [@eval E?] | [how the design earns the score] |

## Risks / things to watch

- [failure mode, side channel, or sharp edge — and how the plan addresses it]

## Tasks

Tracked in `tasks.md`. This plan is the shape; `tasks.md` is the checklist.
