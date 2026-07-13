"""Step implementations for settle-up.feature.

The two property steps ("no suggested payment exceeds ..." and "each
creditor receives ...") recompute balances from the raw ledger text HERE,
independently of the settle package, per the feature's verification
protocol. Nothing in this file imports settle; the tool under test is
exercised only via subprocess (python -m settle), as the SPEC CLI
contract requires.
"""

import csv
import io
import os
import re
import subprocess
import sys
import tempfile

from behave import given, when, then

# steps/ -> units/settle-up/ -> units/ -> project root
PROJECT_ROOT = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..", "..", "..")
)

PAYMENT_RE = re.compile(r"^(?P<payer>.+) pays (?P<payee>.+) \$(?P<dollars>\d+)\.(?P<hundredths>\d{2})$")


# --- independent oracle (must NOT use the settle package) -----------------

def independent_balances(ledger_text: str) -> dict:
    """Recompute per-person balances (cents) straight from the ledger text,
    using SPEC.md's splitting rule. Positive = is owed money."""
    reader = csv.reader(io.StringIO(ledger_text))
    rows = list(reader)
    assert rows and rows[0] == ["payer", "amount", "participants", "description"], (
        "oracle: unexpected header in ledger text"
    )
    balances = {}
    for row in rows[1:]:
        if not row:
            continue
        payer, amount, participants, _desc = row
        dollars, hundredths = amount.split(".")
        cents = int(dollars) * 100 + int(hundredths)
        names = participants.split("+")
        balances[payer] = balances.get(payer, 0) + cents
        share, extra = divmod(cents, len(names))
        for i, name in enumerate(names):
            owed = share + (1 if i < extra else 0)
            balances[name] = balances.get(name, 0) - owed
    return balances


def parsed_payments(stdout_text: str) -> list:
    """(payer, payee, cents) for each payment line on stdout."""
    payments = []
    for line in stdout_text.splitlines():
        m = PAYMENT_RE.match(line)
        if m:
            cents = int(m.group("dollars")) * 100 + int(m.group("hundredths"))
            payments.append((m.group("payer"), m.group("payee"), cents))
    return payments


# --- steps -----------------------------------------------------------------

@given("a ledger file containing:")
def step_given_ledger(context):
    context.ledger_text = context.text
    fd, path = tempfile.mkstemp(prefix="ledger-", suffix=".csv")
    with os.fdopen(fd, "w", encoding="utf-8", newline="") as f:
        f.write(context.text + "\n")
    context.ledger_path = path


@when("the ledger is settled")
def step_when_settled(context):
    result = subprocess.run(
        [sys.executable, "-m", "settle", context.ledger_path],
        cwd=PROJECT_ROOT,
        capture_output=True,
        timeout=30,
    )
    context.stdout = result.stdout.decode("utf-8")
    context.stderr = result.stderr.decode("utf-8")
    context.exit_code = result.returncode


@then("the output is exactly:")
def step_then_output_exactly(context):
    expected = context.text + "\n"
    assert context.stdout == expected, (
        f"stdout mismatch.\nexpected: {expected!r}\nactual:   {context.stdout!r}\n"
        f"stderr:   {context.stderr!r}"
    )


@then("the exit code is {code:d}")
def step_then_exit_code(context, code):
    assert context.exit_code == code, (
        f"expected exit code {code}, got {context.exit_code} "
        f"(stderr: {context.stderr!r})"
    )


@then("exactly {count:d} payments are suggested")
def step_then_payment_count(context, count):
    payments = parsed_payments(context.stdout)
    assert len(payments) == count, (
        f"expected {count} payments, found {len(payments)}: {payments}"
    )


@then("no settlement output is produced")
def step_then_no_stdout(context):
    assert context.stdout == "", (
        f"expected empty stdout, got: {context.stdout!r}"
    )


@then('the error output starts with "{prefix}"')
def step_then_stderr_starts(context, prefix):
    assert context.stderr.startswith(prefix), (
        f"stderr does not start with {prefix!r}: {context.stderr!r}"
    )


@then('the error output mentions "{needle}"')
def step_then_stderr_mentions(context, needle):
    assert needle in context.stderr, (
        f"stderr does not mention {needle!r}: {context.stderr!r}"
    )


@then("no suggested payment exceeds the payer's computed shortfall")
def step_then_no_overpay(context):
    balances = independent_balances(context.ledger_text)
    payments = parsed_payments(context.stdout)
    assert payments, "no payments found on stdout to check"
    paid_total = {}
    for payer, payee, cents in payments:
        shortfall = -balances.get(payer, 0)
        assert shortfall > 0, (
            f"{payer} is not a debtor (balance {balances.get(payer, 0)}) "
            f"but was told to pay"
        )
        assert cents <= shortfall, (
            f"{payer} told to pay {cents} cents in one payment but owes "
            f"only {shortfall}"
        )
        paid_total[payer] = paid_total.get(payer, 0) + cents
    for payer, total in paid_total.items():
        shortfall = -balances[payer]
        assert total <= shortfall, (
            f"{payer} told to pay {total} cents in total but owes only {shortfall}"
        )


@then("each creditor receives in total exactly their computed balance")
def step_then_creditors_made_whole(context):
    balances = independent_balances(context.ledger_text)
    payments = parsed_payments(context.stdout)
    received = {}
    for _payer, payee, cents in payments:
        received[payee] = received.get(payee, 0) + cents
    creditors = {n: b for n, b in balances.items() if b > 0}
    for name, balance in creditors.items():
        got = received.get(name, 0)
        assert got == balance, (
            f"{name} should receive exactly {balance} cents, receives {got}"
        )
    for payee in received:
        assert payee in creditors, (
            f"{payee} receives money but is not a creditor "
            f"(balance {balances.get(payee, 0)})"
        )
