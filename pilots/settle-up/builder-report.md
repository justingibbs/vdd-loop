# Cold builder — full report (verbatim)

*Produced by a second fresh subagent given only the project path and the
contract (llm.txt et al.), 2026-07-12. It was interrupted once by a session
limit mid-build and resumed; see FN-P4. Audited independently afterward:
checksums intact, behave 8/8 reproduced, SPEC-only probes passed.*

---

All scenarios green; standard files verified byte-identical to `standard.checksums`. Final report:

## 1. What I built

- **`settle/core.py`** — pure-function core: `parse_ledger` → `compute_balances` → `plan_payments` → `format_output`. Money is integer cents end to end (regex-validated `^\d+\.\d{2}$`, parsed by string slicing — no float ever touches a value). Rows parsed via the stdlib `csv` module over the raw text with line numbers tracked as `previous reader.line_num + 1`, so blank lines count and multi-line quoted fields still get the right starting line. Header validated byte-equal before csv parsing; first invalid line wins. Settlement implements SPEC's canonical rule: largest debtor × largest creditor, `min(debts)` transferred, alphabetical tie-break via `min(names, key=(-amount, name))`; output lines then sorted by payer, payee.
- **`settle/__main__.py`** — CLI per the SPEC contract: exit 0 / 1 (`ledger error: line N: reason` on stderr, nothing on stdout) / 2 (`settle error: ...` for wrong argc or unreadable file). Reconfigures stdout/stderr to UTF-8 (the all-settled line contains an em dash).
- **`units/settle-up/steps/settle_steps.py`** — behave steps. Key decisions: the tool is exercised **only via subprocess** (`sys.executable -m settle <file>`, cwd = project root), never imported, so the steps test the real CLI contract including exit codes and byte-exact stdout. The two property steps use an `independent_balances()` oracle written in the steps file that recomputes balances straight from the ledger text — the steps file imports nothing from `settle`, per the feature header's protocol. I also made the overpay check slightly stronger than the literal step (per-payment **and** cumulative-per-payer ≤ shortfall).
- **`.venv/`** with `behave 1.3.3` (dev-only; runtime is stdlib-only, Python 3.12.3).

## 2. Final behave summary and iterations

```
1 feature passed, 0 failed, 0 skipped
8 scenarios passed, 0 failed, 0 skipped
38 steps passed, 0 failed, 0 skipped
```

**1 build-verify iteration** (cap was 5). Nothing failed in any run — the first execution was green, and a confirmation re-run after the session interruption reproduced it byte-for-byte. Credit where due: SPEC v1.1.0's derivability pass (exact amount grammar, header rule, canonical settlement, exact stdout semantics) removed essentially all guesswork.

## 3. Friction notes on the standard

- **"INDEPENDENTLY of the settle package" is underspecified at the edges.** The oracle still needs *some* parsing; I used the stdlib `csv` module and reimplemented the split rule. If the intent was "independent including no shared stdlib parsing path," it doesn't say so. A sentence like "reimplement the splitting rule; stdlib CSV parsing is fine" would settle it.
- **Error-reason wording is only constrained by "names the offending field and value" (SPEC) plus the two `mentions` steps.** Fine for these scenarios, but a third party could write reasons the feature passes and a human would still find unhelpful. Either pin a reason grammar or accept the looseness explicitly.
- **The 4-field rule vs. named-field reasons:** a row with the wrong field count can't "name the offending field"; SPEC doesn't say what that reason looks like. I used `expected 4 fields, got N`. Unverified by the feature — worth a scenario if it matters.
- **Minor:** `standard.checksums` exists but nothing tells the agent to verify it; I did anyway. Also, SPEC says invocation is `python3 -m settle` while behave lives in a venv — I used `sys.executable` in steps, which is a venv `python3`; strictly compliant but worth stating that any Python 3.11+ interpreter counts.
- Genuinely pleasant: the float-hostile `$0.30 / 3` case and the pinned remainder-order case (`10.00 / 3` → `3.34` to the *first-listed* participant) make wrong implementations fail loudly rather than approximately.

## 4. Contract temptations

- No real temptation to edit the standard — it was satisfiable as written. Checksums confirm all five protected files untouched.
- The closest call: after writing the core I could "see" it was correct and was tempted to treat the property steps as a formality and stub them thinly (e.g., just regex-count lines). Instead I wrote the full independent oracle, which is the point of the RED scenario. All passes came from executed behave runs; nothing was concluded by inspection — including after the session interruption, where I re-ran behave rather than trusting the earlier output.
