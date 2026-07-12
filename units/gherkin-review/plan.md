# plan.md — gherkin-review

## Shape of the solution

The deliverable is a **procedure document** (`skills/gherkin-review/SKILL.md`)
in the family format, plus the **verification harness** that makes its behavior
mechanically checkable. Two parts:

### 1. The skill (the implementation)

A five-pass review procedure. Passes are ordered so structural problems are
caught before style ones, and each pass is bound to the guideline sections it
enforces (which is what makes R3 cheap — the pass *starts* from the section, so
the citation is native, not retrofitted):

1. **Structural pass** — file naming, one `Feature` block, header comment ties
   to the GREEN goal, `@eval` placement and field validity (5 required fields,
   legal scale, threshold form matches scale).
2. **Scenario pass** — per scenario: one behavior, strict Given→When→Then,
   observable `Then`, declarative language, state-based Givens, concrete data,
   independence, <10 steps.
3. **RED-coverage pass** — negative scenarios assert the *absence of the
   forbidden effect*, not merely an error signal.
4. **Layer-boundary pass** — judgment-y `Then`s flagged toward `@eval`;
   deterministic `@eval` lines flagged toward scenarios.
5. **Report assembly** — findings table (`severity | location | guideline |
   finding`), verdict line, offer of next station.

Severity rubric lives in the SKILL.md so triage is consistent: must-fix = the
loop would build against a lie (unverifiable Then, RED without absence,
malformed @eval, non-independent scenarios); should-fix = trust erosion
(vocabulary drift, bloated Given, missing header); consider = style.

### 2. The verification harness (unit-local, agent-owned)

- `fixtures/` — five seeded-defect `.feature` files, one defect class each,
  otherwise deliberately clean; `manifest.tsv` maps each fixture → location
  token → acceptable guideline citation(s). Alternates are allowed per FN-7.
- `checksums.before` — SHA-256 of every reviewed file, recorded pre-run.
- `runs/<name>.findings.md` — one findings report per skill execution.
- `check_validation.py` — the mechanical runner (FN-6). Asserts, with binary
  exit: every manifest defect found+cited (outline rows), no must-fix on the
  clean exemplar, SKILL.md family conformance, checksums unchanged, every
  citation resolves to a real guideline heading. No LLM in the loop.

## Execution protocol for a verification run

1. Record `checksums.before`.
2. Execute the SKILL.md procedure once per fixture + once on the exemplar,
   writing `runs/*.findings.md`.
3. `python3 check_validation.py` → Validation verdict.
4. Score E1–E3 over the full set of findings reports (judge sees findings +
   criterion descriptions; self-scored this run — disclosed, FN-5).
5. Write `verification-report.md`.

## Risks / known tensions

- **Self-verification collapse (FN-5):** author = implementer = judge this run.
  Mitigated for Validation by the script; Evaluation verdict is provisional.
- **Citation ambiguity (FN-7):** handled by manifest alternates, but the skill
  should prefer the *most specific* applicable section.
- **Stochastic subject:** single execution per fixture this run; if a rerun
  flips a result, that goes straight into field-notes as data.
