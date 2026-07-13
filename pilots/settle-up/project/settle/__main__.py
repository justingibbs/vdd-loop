"""CLI entry point: python3 -m settle <ledger.csv>

Exit codes (SPEC.md):
  0 -- success; settlement lines (or the all-settled line) on stdout
  1 -- ledger error; 'ledger error: line <N>: <reason>' on stderr, no stdout
  2 -- usage error; 'settle error: <reason>' on stderr, no stdout
"""

import sys

from settle.core import (
    LedgerError,
    compute_balances,
    format_output,
    parse_ledger,
    plan_payments,
)


def main(argv: list[str]) -> int:
    # stdout/stderr must be UTF-8 regardless of locale.
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")

    if len(argv) != 1:
        print("settle error: expected exactly one argument: <ledger.csv>",
              file=sys.stderr)
        return 2

    path = argv[0]
    try:
        # UTF-8 text, universal newlines (the default translation mode).
        with open(path, "r", encoding="utf-8") as f:
            text = f.read()
    except (OSError, UnicodeDecodeError) as exc:
        print(f"settle error: cannot read {path}: {exc}", file=sys.stderr)
        return 2

    try:
        expenses = parse_ledger(text)
    except LedgerError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    balances = compute_balances(expenses)
    payments = plan_payments(balances)
    sys.stdout.write(format_output(payments))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
