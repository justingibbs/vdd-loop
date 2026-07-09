# verification-report.md — password-reset

*Written by the verifier at the end of each loop run. Reports pass/fail per
`.feature` scenario. This unit is pure Validation — there are no `@eval` lines,
so the Evaluation section is empty by design.*

**Unit:** password-reset
**Verification standard:** `password-reset.feature` (7 scenarios), no `@eval` criteria
**Result:** ✅ PASS — 7/7 scenarios passing on loop iteration 2

---

## Validation layer — `.feature` scenarios

| Scenario | Iter 1 | Iter 2 |
|----------|:------:|:------:|
| Requesting a reset for a registered address issues a link | ✅ | ✅ |
| A valid token lets the user set a new password and log in | ✅ | ✅ |
| The previous password stops working after a successful reset | ✅ | ✅ |
| An expired token never grants access | ✅ | ✅ |
| A token cannot be used twice | ✅ | ✅ |
| A new password that violates the policy is rejected | ✅ | ✅ |
| Requesting a reset for an unregistered address reveals nothing | ❌ | ✅ |

## Evaluation layer — `@eval` criteria

*None. This unit has no BLUE (evaluation) cards and therefore no `@eval` lines.
Nothing here requires judgment to assess.*

---

## Iteration 1 — one failure, looped back

**❌ Requesting a reset for an unregistered address reveals nothing**

- **What was attempted:** the request handler returned early on the not-found
  branch, before doing any token hashing or delivery work.
- **Why it failed:** the early return made the not-found path measurably faster
  than the registered path. The scenario's assertion that the response is
  *identical* to a registered request failed on response timing — a classic
  account-enumeration side channel. The body and status matched; the timing did
  not.
- **What was needed:** perform equivalent work on both branches (a dummy hash on
  the not-found path) so the two responses are indistinguishable in body, status,
  and timing.

The loop applied that fix (see `plan.md` → *Risks → Timing side channel*) and
re-ran.

## Iteration 2 — all green

All 7 scenarios pass. The registered and unregistered branches are now
indistinguishable, and every RED scenario leaves the stored password unchanged.

## Stop condition

The verification standard is fully met (Validation layer green, no Evaluation
layer to satisfy). The loop halts here. No `schema-change-proposal.md` was
needed — the feature fit entirely within the existing `SPEC.md` constraints.
