# plan.md — password-reset

*Agent-generated architecture for this feature specifically. Derived from
`requirements.md` and the constraints in `SPEC.md`. Describes how the code will
satisfy the `.feature` scenarios — not a restatement of them.*

---

## Approach in a paragraph

Add a reset-token model backed by the existing Postgres user store, plus two
operations: **request** (issue + deliver a token) and **consume** (validate a
token and set a new password). The token is a random opaque value; only its hash
is stored, with an issued-at timestamp and a used-at nullable timestamp. Expiry
and single-use are enforced at consume time by checking those two columns. Account
enumeration is prevented by making the request operation's externally observable
behavior identical regardless of whether the address is registered.

## Data model (touches existing user store)

New table `password_reset_tokens`:

| Column | Type | Notes |
|--------|------|-------|
| `id` | uuid | pk |
| `user_id` | uuid | fk → users.id |
| `token_hash` | text | hash of the opaque token; raw token never stored |
| `issued_at` | timestamptz | used for the 15-minute expiry check |
| `used_at` | timestamptz null | null until consumed; set on first successful use |

No change to the `users` table beyond writing the new `password_hash` on a
successful reset. **This introduces no new datastore** (constraint satisfied).

## Operations

### Request reset  → satisfies R1, R7
1. Look up the user by email.
2. If found: create a token row (`issued_at = now`, `used_at = null`), and send
   the raw token via the existing email transport.
3. If not found: do nothing internally.
4. **Return the same response and timing profile in both cases** — no signal of
   whether the address is registered (R7).

### Consume reset  → satisfies R2–R6
1. Hash the presented token; look up the matching row.
2. Reject if no row, if `used_at` is non-null (already used → R5), or if
   `now - issued_at > 15 min` (expired → R4). On any rejection, **do not modify
   the password** (R4/R5 postconditions).
3. Validate the new password against the existing policy; reject on violation
   without modifying the password (R6).
4. On success: write the new `password_hash`, set `used_at = now` (single-use),
   and invalidate existing sessions so the old password is fully dead (R3).

## How each scenario is satisfied

| Scenario | Mechanism |
|----------|-----------|
| Issues a link | Request op creates a token row + sends link |
| Valid token → new password → login | Consume op writes new hash; login uses it |
| Previous password stops working | New hash replaces old; sessions invalidated |
| Expired token rejected | `now - issued_at > 15 min` check before any write |
| Token cannot be reused | `used_at` non-null check before any write |
| Policy violation rejected | Policy check before any write |
| Unregistered address reveals nothing | Identical response/timing on both branches |

## Risks / things to watch

- **Timing side channel (R7):** the not-found branch must do comparable work to
  the found branch, or response timing leaks account existence. Plan: perform a
  dummy hash on the not-found path.
- **Clock skew on expiry:** expiry is evaluated server-side against `issued_at`;
  no reliance on client clocks.
- **Token entropy:** the opaque token must be generated from a CSPRNG; a weak
  token undermines every RED scenario at once.

## Tasks

Atomic units are tracked in `tasks.md` (agent-owned). This plan is the shape;
`tasks.md` is the checklist.
