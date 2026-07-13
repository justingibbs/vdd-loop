# Derivability probe — full report (verbatim)

*Produced by a fresh subagent given only the handoff set (llm.txt, CLAUDE.md,
SPEC.md 1.0.0, settle-up.goals, settle-up.feature), read-only, 2026-07-12 —
before the SPEC 1.1.0 revisions that closed the risky gaps below.*

---

## A. The Cold Reading

This is a VDD (verification-driven) unit for `settle-up`: a stateless CLI calculator, `python3 -m settle <ledger.csv>`, Python 3.11+ stdlib only, that reads a CSV ledger (`payer,amount,participants,description`), computes per-person balances in integer cents, and prints a short list of `"<payer> pays <payee> $<amount>"` lines (sorted payer-then-payee) that settles the group, or `"All settled — no payments needed."`, or on any bad row exits 1 with `ledger error: line <N>: <reason>` on stderr and nothing on stdout. Splits are exact: `floor(A/n)` cents each, first `A mod n` participants in listed order pay one extra cent. "Done" is defined by 8 behave scenarios in `settle-up.feature` (5 happy-path with byte-pinned outputs, 3 negative), plus SPEC constraints (never more than P−1 payments, deterministic byte-for-byte output, no floats near money). There is deliberately no `@eval` layer. I would build a small `settle` package (parse → balances → settle → format), a `__main__`, and behave step implementations under the unit folder, then loop until the 8 scenarios pass. The handoff set is genuinely buildable-from; the happy path is tightly pinned, but the input-validation surface and the "which settlement, for ledgers not in the file" question are where two builders diverge.

## B. Load-Bearing Design Decisions

1. **Settlement algorithm and tie-breaking.** Partially CONSTRAINED: P−1 bound and "canonical cases pin exact payments" (SPEC Constraints), output sort order, and the goals note that global minimality is NP-hard and only known cases are pinned (`settle-up.goals`, Verification intent G1). GUESS: for any ledger with ≥2 creditors and ≥2 debtors whose amounts don't pair up (no such case in the `.feature` — the four-person scenario pairs exactly, the cabin scenario has one creditor), multiple valid P−1 settlements exist and nothing says which one is canonical. Determinism requires *a* stable answer, not *the* answer. Greedy largest-vs-largest passes every pinned case, but so would other schemes.

2. **Lexical grammar of `amount`.** Partially CONSTRAINED: "decimal string, e.g. `12.50`; parsed to exact cents", integer-cents/no-floats constraint, and `twelve` must fail. GUESS: negative amounts, zero, `12.5`, `.50`, `12.505`, `1,000.00`, `$12.50`, surrounding whitespace, `1e2`. Each is a coin-flip between "parse it" and "ledger error."

3. **CSV parsing mechanics.** CONSTRAINED only to "CSV" with a verbatim header. GUESS: Python `csv` module (quoted commas in `description` survive) vs. naive `split(',')` (they don't); whether the header is validated at all and what happens when it isn't verbatim; behavior for rows with ≠4 fields; blank lines; field whitespace trimming.

4. **Error policy breadth and ordering.** Partially CONSTRAINED: format `ledger error: line <N>: <reason>`, exit 1, empty stdout; two concrete cases pinned (non-numeric amount at line 3, empty participants at line 2) — note line 3's error must be reported even though line 2 is valid, implying row-by-row scanning. GUESS: first-error-wins vs. all errors; whether empty `payer`, duplicate/empty participant names (`alice++bob`), or bad header are errors; and — entirely undefined — behavior for non-ledger failures (missing file, no argument), which don't fit the "line N" error shape at all.

5. **Test wiring / step semantics.** CONSTRAINED loosely: behave in a venv, steps in `units/settle-up/steps/` or a `features/` tree, "your call" (CLAUDE.md); executed checks only, never inspection (llm.txt contract). GUESS: subprocess vs. in-process invocation; what "the output is exactly" means about trailing newline (byte-for-byte is demanded but the builder authors the equality check); how the two property steps ("no payment exceeds shortfall", "creditor receives exactly their balance") compute balances — independently in step code, or by calling the tool's own functions, which would make the check circular.

6. **Money formatting.** CONSTRAINED: `$` prefix, always two decimals, all pinned outputs agree. Only residual guess is thousands separators for large amounts (implied absent, never stated).

## C. Gaps

No gap is outright **blocking** — the pinned scenarios are tight enough that a competent builder passes the standard either way. But that is exactly the finding: the standard is airtight *for the 8 pinned inputs* and silent on a wide validation surface, so two green implementations can behave very differently on real ledgers. Risky and note gaps:

**Risky (two builders plausibly diverge; owner intent unclear):**

1. **Negative/zero/over-precise amounts** — settle with: "`amount` must match `\d+\.\d{2}` (nonzero); anything else is a line error naming `amount`." Bears directly on G3.
2. **Header validation** — SPEC says the header *is* verbatim, not that the tool *checks* it. Settle with: "A first line not byte-equal to `payer,amount,participants,description` is `ledger error: line 1:`."
3. **Header-only / empty file** — nowhere. Settle with: "A header-only ledger is valid and prints the all-settled line; a zero-byte file is an error."
4. **Quoted commas in `description` / wrong column count** — settle with: "Parse with `csv` module semantics; rows with ≠4 fields are line errors."
5. **Non-ledger failures** (file missing, unreadable, wrong argv) — the error contract presumes a line number, so this case has *no* defined exit code or message. Settle with one sentence assigning an exit code and stderr shape.
6. **Duplicate participants (`alice+alice`) and empty components (`alice++bob`)** — settle with: "Empty or repeated names in `participants` are line errors."
7. **Canonical settlement for unpinned ledgers** — goals G1 intent + SPEC determinism pin *stability*, not *which* settlement. Settle with: "Repeatedly match the largest debtor to the largest creditor, ties alphabetical."
8. **Circularity of the RED property steps** — nothing says the step's "computed shortfall/balance" must be computed independently of the package under test. Settle with: "Property steps recompute balances from the ledger text in step code, not via the settle package." Without this the strongest G2 checks can silently verify the tool against itself.

**Note (friction only):**

9. **Trailing newline / "output is exactly" semantics** — one sentence pinning "stdout is the shown lines joined by `\n` plus a final newline, UTF-8" would remove self-grading wiggle. (The em dash in the all-settled line also quietly assumes UTF-8.)
10. **Whitespace in fields** — settle with "fields are used verbatim; no trimming."
11. **Name identity** — case sensitivity/Unicode normalization. Settle with "names compare byte-exact."
12. **Payer not in participants** — constrained as legal by SPEC wording, but no scenario exercises it.
13. **Multiple bad rows** — settle with "report the first invalid line in file order and stop."
14. **CRLF endings / trailing blank line** — affects line numbering and blank-row handling.
15. **`And exactly 2 payments are suggested`** is redundant with the byte-exact output above it — harmless.

**Overall verdict:** derivable. The handoff set constrains the architecture, money model, splitting rule, CLI shape, and all pinned outcomes well; the residual guesses cluster in (a) input-validation grammar (the G3 surface), (b) undefined non-ledger failure modes, and (c) verification-protocol self-grading (equality semantics and the independence of the property steps). Roughly ten one-sentence additions to SPEC.md would close everything above note level.

---

*Disposition: all 8 risky gaps were closed before handoff (SPEC 1.1.0 + a
protocol addition to the `.feature` header). See the pilot README.*
