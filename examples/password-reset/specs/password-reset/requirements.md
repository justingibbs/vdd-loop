# requirements.md — password-reset

> *A self-service back door that's safe because it's time-boxed and single-use.*
> — Design Concept (🟪 PURPLE), from the Goal Storming session for this feature.

*Agent-generated. This is the loop's interpretation of `password-reset.feature`
plus the constraints it inherits from the project `SPEC.md`. It is scaffolding,
not source of truth — if it disagrees with the `.feature` file, the `.feature`
file wins.*

---

## Goal (🟩 GREEN)

A user who has forgotten their password can regain access to their account
**without contacting support.**

Every requirement below traces to that goal. If a requirement doesn't serve it,
it's scope creep and should be removed.

## Scope

- **In scope:** requesting a reset, issuing a time-boxed single-use token,
  delivering it, validating it, setting a new password, invalidating the old one.
- **Out of scope:** account registration, login itself, session management,
  the email transport implementation, multi-factor enrollment.

## Constraints inherited from SPEC.md (⬛ BLACK)

- Reset tokens expire **within 15 minutes** of issuance (compliance).
- Tokens are **single-use** — consumed on first successful reset.
- Use the **existing Postgres user store**; introduce no new datastore.
- New passwords must satisfy the **existing password policy** (owned by SPEC.md,
  not redefined here).

## Functional requirements

Each requirement names the `.feature` scenario that verifies it. The aim is that
every requirement is backed by a verification — and in this feature, every one is.
Where a verification can't be found yet, that's a known gap to revisit, not a
blocker.

| # | Requirement | Verified by (scenario) |
|---|-------------|------------------------|
| R1 | A reset request for a registered address issues a single-use token and delivers a link. | *Requesting a reset for a registered address issues a link* |
| R2 | A valid, unexpired token allows setting a new policy-compliant password, after which the user can log in with it. | *A valid token lets the user set a new password and log in* |
| R3 | After a successful reset, the previous password no longer works. | *The previous password stops working after a successful reset* |
| R4 | An expired token (>15 min old) is rejected and leaves the password unchanged. | *An expired token never grants access* |
| R5 | A token that has already been used is rejected and leaves the password unchanged. | *A token cannot be used twice* |
| R6 | A new password that violates the policy is rejected and leaves the password unchanged. | *A new password that violates the policy is rejected* |
| R7 | A reset request for an unregistered address is indistinguishable from one for a registered address, and sends no link (no account enumeration). | *Requesting a reset for an unregistered address reveals nothing* |

## Non-goals / explicit non-requirements

- The system does **not** tell the requester whether an address is registered
  (R7 is a privacy guardrail, not a UX affordance).
- The system does **not** rate-limit here — that's a project-level concern
  tracked in SPEC.md, not this feature.

## Open questions surfaced during interpretation

- None blocking. Token delivery assumes the project's existing email transport;
  if that transport doesn't exist yet, this feature has an unstated dependency
  and the loop should pause and flag it.
