# tasks.md — password-reset

*Agent-generated and agent-tracked. Atomic, implementable units derived from
`plan.md`. Checked off as the loop implements and re-verifies. This file is a
working checklist, not a source of truth.*

---

## Tasks

- [x] **T1** — Add `password_reset_tokens` table (id, user_id, token_hash,
      issued_at, used_at) to the existing Postgres schema. *(→ R1)*
- [x] **T2** — Implement token generation from a CSPRNG; store only the hash.
      *(→ R1, underpins R4–R5)*
- [x] **T3** — Implement the **request** operation: look up user, create token
      row, deliver link via existing email transport. *(→ R1)*
- [x] **T4** — Make request response identical on found/not-found, including a
      dummy hash on the not-found path to close the timing side channel.
      *(→ R7 — the fix applied in loop iteration 2)*
- [x] **T5** — Implement the **consume** operation: hash lookup, expiry check
      (`now - issued_at > 15m`), single-use check (`used_at`), policy check —
      each rejecting before any write. *(→ R2, R4, R5, R6)*
- [x] **T6** — On successful consume: write new password_hash, set
      `used_at = now`, invalidate existing sessions. *(→ R2, R3)*
- [x] **T7** — Wire scenarios in `password-reset.feature` to the implementation
      and run them in the loop. *(→ all)*

## Notes

- T4 was added/expanded after loop iteration 1 flagged the enumeration timing
  leak. See `verification-report.md` → *Iteration 1*.
- All tasks trace to a requirement in `requirements.md`, which in turn traces to
  a `.feature` scenario. A task that serves no requirement would be scope creep.
