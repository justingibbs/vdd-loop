# SPEC.md — settle-up

**Version:** 1.1.0
**Status:** active
**Last updated:** 2026-07-12

> **Design Concept (🟪):** The receipt pile in, the Venmo list out.

---

## What we're building

`settle-up` is a command-line tool for groups that shared expenses. It reads a
ledger file (CSV) of who paid for what and who shared it, and prints the
payments that settle everyone up — as few payments as practical, exact to the
cent. It is a calculator, not a service: no accounts, no state, no network.

## Architecture

A single small Python package, pure functions at the core: parse ledger →
compute per-person balances → compute settlement payments → format output.
No persistence, no third-party runtime dependencies.

## Data model

```yaml
# One CSV file. Line 1 is the header, verbatim:
#   payer,amount,participants,description
ledger-row:
  payer: string            # a person's name; any non-empty string
  amount: dollars          # decimal string, e.g. "12.50"; parsed to exact cents
  participants: string     # names joined by "+", e.g. "alice+bob+carol".
                           # The people splitting this expense. Includes the
                           # payer when the payer shares in it (the payer need
                           # not be a participant).
  description: string      # free text; not used in computation
```

**Input discipline (all are `ledger error`s unless stated):**

- `amount` must match `^\d+\.\d{2}$` and be greater than zero; anything else —
  negative, zero, `12.5`, `.50`, `12.505`, `$12.50`, `1,000.00`, whitespace —
  is a line error naming `amount`.
- Line 1 must be byte-equal to `payer,amount,participants,description`;
  otherwise `ledger error: line 1: bad header`. A header-only ledger is valid
  (prints the all-settled line); a zero-byte file is `ledger error: line 1:
  missing header`.
- Rows are parsed with Python `csv` module semantics (quoted commas in
  `description` survive); a row with other than 4 fields is a line error.
- Empty or repeated names in `participants` (e.g. `alice++bob`, `alice+alice`)
  and an empty `payer` are line errors.
- Fields are used verbatim — no whitespace trimming; names compare byte-exact
  (`Alice` ≠ `alice`).
- Files are read as UTF-8 text with universal newlines; blank lines are
  skipped as data but still count toward line numbers.
- Validation reports the **first** invalid line in file order, then stops.

**Splitting rule (exact, deterministic):** an expense of `A` cents split among
`n` participants: each pays `floor(A / n)` cents; the first `A mod n`
participants *in the row's listed order* pay one extra cent.

**Balance:** for each person, cents paid minus cents owed. Positive = is owed
money; negative = owes.

## CLI contract

```yaml
invocation: python3 -m settle <ledger.csv>
success:
  exit: 0
  stdout:
    - one line per suggested payment, in this exact form:
        "<payer> pays <payee> $<amount>"          # amount always two decimals,
                                                  # no thousands separators
    - lines sorted by payer name, then payee name (alphabetical)
    - when no payments are needed: the single line
        "All settled — no payments needed."
    - encoding UTF-8; stdout is exactly the lines joined by "\n"
      plus one final newline
ledger-error:
  exit: 1
  stdout: nothing — no settlements may be printed on any error
  stderr: 'ledger error: line <N>: <reason>'
          # N = the line number in the file (header is line 1);
          # <reason> names the offending field and value
usage-error:                # missing/unreadable file, wrong arguments —
  exit: 2                   # anything that is not a ledger line problem
  stdout: nothing
  stderr: 'settle error: <reason>'
```

**Settlement rule (canonical, deterministic):** repeatedly match the largest
debtor to the largest creditor for the smaller of the two amounts; break ties
alphabetically by name. (This yields at most `P − 1` payments and makes every
output reproducible byte for byte.)

## Non-functional requirements (NFRs)

- Runs on a stock Python installation; no network access; input files up to a
  few thousand rows are effectively instant.

## Constraints (⬛ from Goal Storming)

*This section is the part of SPEC.md that most binds the coding agent.*

- **Python 3.11+, standard library only** for the tool itself.
- **`behave` is the BDD runner** for the verification standard (dev dependency
  only, installed in a virtualenv).
- **Money is integer cents internally.** Binary floating point must never
  touch a monetary value.
- **Deterministic output** — same ledger, same output, byte for byte (the
  sorting rule above exists for this).
- **Settlement quality:** never more than `P − 1` payments, where `P` is the
  number of people with a nonzero balance; the canonical cases in the
  `.feature` pin exact expected payments.

## Out of scope

- Currencies other than a single implicit one; exchange rates.
- Unequal/weighted splits; percentages.
- Persistence, accounts, undo, or any service behavior.

---

## Change log

- **1.1.0** — 2026-07-12 — closed the risky gaps found by the pre-handoff
  derivability probe: amount grammar, header validation, empty/zero-byte
  files, csv-module semantics and field-count rule, participant name rules,
  verbatim fields and byte-exact names, first-error-wins, usage-error contract
  (exit 2), canonical settlement rule, exact stdout equality semantics.
- **1.0.0** — 2026-07-12 — initial spec, from the settle-up Goal Storming session.
