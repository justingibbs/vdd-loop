## derivability-review — units/settle-up/ (2026-07-12, pre-handoff)

Probe: a genuinely fresh subagent, given ONLY the handoff set (llm.txt,
CLAUDE.md, SPEC.md, settle-up.goals, settle-up.feature), read-only.

Verdict: **DERIVABLE** — no blocking gaps. 8 risky gaps + 7 notes found,
clustered in: (a) input-validation grammar (the G3 surface), (b) undefined
non-ledger failure modes, (c) verification self-grading (output-equality
semantics; the RED property steps could circularly verify the tool against
itself).

Disposition: ALL risky gaps closed before handoff — SPEC.md 1.0.0 → 1.1.0
(input discipline block, usage-error contract, canonical settlement rule,
exact stdout semantics) and a protocol addition to the .feature header
(property steps must recompute balances independently of the code under
test). The probe's full report is preserved in the pilot record.

Sharpest catch: the probe noticed the standard was airtight for the 8 pinned
inputs but silent on the wider validation surface — "two green implementations
can behave very differently on real ledgers." Exactly the failure mode this
skill exists to expose.
