# fixture-red-no-absence.feature
#
# Verification standard for the account-lockout unit.
# Goal (GREEN): Repeated failed logins cannot be used to brute-force an account.

Feature: Account lockout
  As an account owner
  I want my account locked after repeated failed logins
  So that my password cannot be brute-forced

  Scenario: Five failed attempts lock the account
    Given the account "maria@example.com" has 4 consecutive failed login attempts
    When a fifth login attempt fails
    Then the account is locked for 30 minutes

  # --- RED: negative validation ---

  Scenario: A locked account never allows login
    Given the account "maria@example.com" is locked
    When Maria submits her correct password
    Then an error message is shown
