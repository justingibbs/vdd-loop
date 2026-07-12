<!--
  SPEC.md — TEMPLATE. Copy into your project root and fill in.

  SPEC.md is the CONSTRAINT SURFACE for the whole project. It is the residue of
  Goal Storming's BLACK (constraint) cards, plus the project-level Design Concept
  and the architecture the team commits to.

  Two rules that make SPEC.md different from every other artifact:
    1. VERSIONED — bump the version on every change (see header).
    2. PROTECTED — the agent must NEVER edit this file without explicit human
       approval. If a feature needs a SPEC change, the agent writes
       units/<name>/schema-change-proposal.md and PAUSES for review.
       (That rule is restated in CLAUDE.md, where the agent will read it.)

  Format guidance: Markdown for narrative sections; YAML for deeply nested
  structured data (data model, API contracts) — nesting deeper than ~3 levels
  reads more reliably in YAML than in prose or tables.

  Delete these comments once the file is filled in.
-->

# SPEC.md — [Project Name]

**Version:** 1.0.0
**Status:** [draft | active]
**Last updated:** [YYYY-MM-DD]

> **Design Concept (🟪):** [One-breath statement of what this project is —
> succinct and enticing. The project-level output of Goal Storming's PURPLE card.
> If you also keep a README, this line is the hook at the top of it.]

---

## What we're building

[A few paragraphs: the product in plain language. What it does, who it serves, the
shape of the whole. This is the longer-form companion to the Design Concept above.]

## Architecture

[The overarching technical approach: major components and how they fit together. A
diagram or bullet list is fine. Keep it at the level of decisions, not code.]

## Data model

<!-- Use YAML for anything nested deeper than a couple of levels. -->
```yaml
# entities and their fields — the shape of the data, not the DDL
# example:
# user:
#   id: uuid
#   email: string (unique)
#   password_hash: string
```

## API contracts

```yaml
# endpoints / operations and their inputs and outputs
# example:
# POST /reset/request:
#   in:  { email: string }
#   out: { status: accepted }   # identical whether or not the email is registered
```

## Architecture Decision Records (ADRs)

<!-- One entry per significant, hard-to-reverse decision. Keep the reasoning. -->
### ADR-001: [Title]
- **Decision:** [what was decided]
- **Context:** [what forced the decision]
- **Consequences:** [what this makes easy, what it makes hard]

## Non-functional requirements (NFRs)

[Performance, availability, security posture, compliance, accessibility — the
qualities any solution must hold to, expressed as constraints, not features.]

## Constraints (⬛ from Goal Storming)

[The BLACK cards. What any solution must respect regardless of approach: tooling
limits, datastore choices, regulatory boundaries. Constraints, not designs —
"must use the existing Postgres store," not the schema itself.

This section is the part of SPEC.md that most binds the coding agent — the rest
of the file is context; these are the boundaries no build may cross.]

- [constraint]
- [constraint]

## Out of scope

[What this project explicitly does not do. Guards against scope creep as much as the
in-scope sections define the work.]

- [out of scope item]

---

## Change log

<!-- Bump the version above and add a line here on every change. -->
- **1.0.0** — [YYYY-MM-DD] — initial spec.
