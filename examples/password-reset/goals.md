# goals.md — password-reset

## Goals

- 🟩 G1: A user who forgot their password can regain access to their account without contacting support.

## Verification intent

- G1: Entirely deterministic — expiry, single-use, policy enforcement, and account
  enumeration resistance are all binary outcomes a BDD runner can confirm. No
  judgment layer needed. See `password-reset.feature` for all scenarios.

## Design Concept *(🟪)*

> *"A self-service back door that's safe because it's time-boxed and single-use."*

## Constraints *(⬛ from SPEC.md)*

- Tokens expire within 15 minutes of issuance (compliance).
- Tokens are single-use — consumed on first successful reset.
- Use the existing Postgres user store; introduce no new datastore.
- New passwords must satisfy the existing password policy.
