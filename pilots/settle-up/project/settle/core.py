"""Core logic for settle-up.

All monetary values are integer cents. All functions are pure.
Contracts (header grammar, amount grammar, splitting rule, settlement
rule, output forms) are pinned in SPEC.md v1.1.0.
"""

from __future__ import annotations

import csv
import io
import re
from dataclasses import dataclass

HEADER = "payer,amount,participants,description"

# ^\d+\.\d{2}$ per SPEC.md; value must additionally be > 0.
_AMOUNT_RE = re.compile(r"^\d+\.\d{2}$")


class LedgerError(Exception):
    """A problem with a specific line of the ledger file."""

    def __init__(self, line: int, reason: str):
        self.line = line
        self.reason = reason
        super().__init__(f"ledger error: line {line}: {reason}")


@dataclass(frozen=True)
class Expense:
    payer: str
    cents: int
    participants: tuple[str, ...]  # in listed order (remainder cents rule)


def _parse_amount(text: str, line: int) -> int:
    if not _AMOUNT_RE.match(text):
        raise LedgerError(line, f"bad amount {text!r}")
    cents = int(text[:-3]) * 100 + int(text[-2:])
    if cents == 0:
        raise LedgerError(line, f"amount must be greater than zero, got {text!r}")
    return cents


def _parse_participants(text: str, line: int) -> tuple[str, ...]:
    names = text.split("+")
    if any(name == "" for name in names):
        raise LedgerError(line, f"empty name in participants {text!r}")
    if len(set(names)) != len(names):
        raise LedgerError(line, f"repeated name in participants {text!r}")
    return tuple(names)


def parse_ledger(text: str) -> list[Expense]:
    """Parse ledger text (UTF-8, universal newlines already applied).

    Raises LedgerError for the FIRST invalid line in file order.
    """
    if text == "":
        raise LedgerError(1, "missing header")

    first_line = text.split("\n", 1)[0]
    if first_line != HEADER:
        raise LedgerError(1, "bad header")

    expenses: list[Expense] = []
    reader = csv.reader(io.StringIO(text))
    prev_line_num = 0
    header_seen = False
    for row in reader:
        start_line = prev_line_num + 1
        prev_line_num = reader.line_num
        if not header_seen:
            header_seen = True  # line 1, validated byte-equal above
            continue
        if not row:
            continue  # blank line: skipped as data, still counts for numbering
        if len(row) != 4:
            raise LedgerError(start_line, f"expected 4 fields, got {len(row)}")
        payer, amount, participants, _description = row
        if payer == "":
            raise LedgerError(start_line, "empty payer")
        cents = _parse_amount(amount, start_line)
        names = _parse_participants(participants, start_line)
        expenses.append(Expense(payer, cents, names))
    return expenses


def compute_balances(expenses: list[Expense]) -> dict[str, int]:
    """Cents paid minus cents owed, per person. Positive = is owed money.

    Splitting rule: A cents among n participants -> each pays floor(A/n);
    the first A mod n participants in listed order pay one extra cent.
    """
    balances: dict[str, int] = {}
    for exp in expenses:
        balances[exp.payer] = balances.get(exp.payer, 0) + exp.cents
        share, extra = divmod(exp.cents, len(exp.participants))
        for i, name in enumerate(exp.participants):
            owed = share + (1 if i < extra else 0)
            balances[name] = balances.get(name, 0) - owed
    return balances


def plan_payments(balances: dict[str, int]) -> list[tuple[str, str, int]]:
    """Canonical settlement: repeatedly match the largest debtor to the
    largest creditor for the smaller of the two amounts; ties broken
    alphabetically by name. Returns (payer, payee, cents) tuples.
    """
    debtors = {n: -b for n, b in balances.items() if b < 0}
    creditors = {n: b for n, b in balances.items() if b > 0}
    payments: list[tuple[str, str, int]] = []
    while debtors and creditors:
        debtor = min(debtors, key=lambda n: (-debtors[n], n))
        creditor = min(creditors, key=lambda n: (-creditors[n], n))
        amount = min(debtors[debtor], creditors[creditor])
        payments.append((debtor, creditor, amount))
        debtors[debtor] -= amount
        creditors[creditor] -= amount
        if debtors[debtor] == 0:
            del debtors[debtor]
        if creditors[creditor] == 0:
            del creditors[creditor]
    return payments


def _format_cents(cents: int) -> str:
    return f"{cents // 100}.{cents % 100:02d}"


def format_output(payments: list[tuple[str, str, int]]) -> str:
    """Exact stdout: lines sorted by payer then payee, joined by newlines,
    one final newline."""
    if not payments:
        return "All settled — no payments needed.\n"
    lines = [
        f"{payer} pays {payee} ${_format_cents(cents)}"
        for payer, payee, cents in sorted(payments, key=lambda p: (p[0], p[1]))
    ]
    return "\n".join(lines) + "\n"
