# settle-up.feature
#
# Verification standard for the settle-up unit. Scenarios come from Goal
# Storming's YELLOW (validation) and RED (negative validation) cards.
# Goals (GREEN, ratified 2026-07-12 — see settle-up.goals):
#   G1: who-pays-whom in as few payments as possible, no user arithmetic.
#   G2: trustworthy — money conserved to the cent, never overpay.
#   G3: bad ledgers are rejected with exact reasons, never guessed at.
#
# No @eval lines — every outcome is deterministic (no Evaluation layer, by design).
#
# Verification protocol: executed with behave. The ledger contract (CSV columns,
# splitting rule, CLI output forms, error format) is pinned in SPEC.md — read it
# before implementing steps. Amount expectations below are exact, to the cent.
# "The output is exactly" means: stdout, UTF-8, equal to the shown lines joined
# by "\n" plus one final newline. The two property steps in the never-overpay
# scenario must recompute balances from the ledger text in step code,
# INDEPENDENTLY of the settle package — never by calling the code under test.

Feature: Expense settlement
  As a member of a group that shared expenses
  I want the payments that settle everyone up
  So that we're square without anyone doing arithmetic

  # --- YELLOW: validations ---

  Scenario: Two people settle with a single exact payment
    Given a ledger file containing:
      """
      payer,amount,participants,description
      alice,60.00,alice+bob,dinner
      bob,20.00,alice+bob,taxi
      """
    When the ledger is settled
    Then the output is exactly:
      """
      bob pays alice $20.00
      """
    And the exit code is 0

  Scenario: Uneven splits assign remainder cents by listed order
    Given a ledger file containing:
      """
      payer,amount,participants,description
      carol,10.00,alice+bob+carol,pizza
      """
    When the ledger is settled
    Then the output is exactly:
      """
      alice pays carol $3.34
      bob pays carol $3.33
      """
    And the exit code is 0

  Scenario: A balanced ledger needs no payments
    Given a ledger file containing:
      """
      payer,amount,participants,description
      alice,10.00,alice+bob,lunch
      bob,10.00,alice+bob,museum
      """
    When the ledger is settled
    Then the output is exactly:
      """
      All settled — no payments needed.
      """
    And the exit code is 0

  Scenario: Four people with matching debts settle in two payments
    Given a ledger file containing:
      """
      payer,amount,participants,description
      dan,40.00,dan+erin,hotel
      frank,10.00,frank+gina,breakfast
      """
    When the ledger is settled
    Then the output is exactly:
      """
      erin pays dan $20.00
      gina pays frank $5.00
      """
    And exactly 2 payments are suggested
    And the exit code is 0

  Scenario: Cent amounts stay exact where floating point would drift
    Given a ledger file containing:
      """
      payer,amount,participants,description
      alice,0.30,alice+bob+carol,coffee
      """
    When the ledger is settled
    Then the output is exactly:
      """
      bob pays alice $0.10
      carol pays alice $0.10
      """
    And the exit code is 0

  # --- RED: negative validations ---

  Scenario: No one is ever told to pay more than they owe
    Given a ledger file containing:
      """
      payer,amount,participants,description
      hana,90.00,hana+ivan+june,cabin
      ivan,30.00,ivan+june,fuel
      """
    When the ledger is settled
    Then the output is exactly:
      """
      ivan pays hana $15.00
      june pays hana $45.00
      """
    And no suggested payment exceeds the payer's computed shortfall
    And each creditor receives in total exactly their computed balance

  Scenario: A non-numeric amount stops settlement with the line named
    Given a ledger file containing:
      """
      payer,amount,participants,description
      alice,12.50,alice+bob,groceries
      bob,twelve,alice+bob,cinema
      """
    When the ledger is settled
    Then no settlement output is produced
    And the error output starts with "ledger error: line 3:"
    And the error output mentions "amount"
    And the exit code is 1

  Scenario: A row with no participants stops settlement with the line named
    Given a ledger file containing:
      """
      payer,amount,participants,description
      alice,7.00,,parking
      """
    When the ledger is settled
    Then no settlement output is produced
    And the error output starts with "ledger error: line 2:"
    And the error output mentions "participants"
    And the exit code is 1
