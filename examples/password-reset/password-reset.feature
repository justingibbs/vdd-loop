# password-reset.feature
#
# The Validation layer for the password-reset feature.
# Output of Goal Storming's YELLOW (validation) and RED (negative
# validation) cards. This is the deterministic, binary standard the
# agent loop checks against — every scenario here either passes or fails.
#
# Goal (GREEN): A user who forgot their password can regain access to
#               their account without contacting support.
#
# No BLUE (evaluation) cards exist for this feature — nothing here
# requires judgment, so there is no accompanying .rubric.md.

Feature: Password reset
  As a user who has forgotten my password
  I want to reset it through a time-boxed, single-use link
  So that I can regain access to my account without contacting support

  Background:
    Given a registered account exists for "user@example.com"

  # --- YELLOW: validations (the happy path that proves the goal) ---

  Scenario: Requesting a reset for a registered address issues a link
    When a password reset is requested for "user@example.com"
    Then a single-use reset link is sent to "user@example.com"
    And the link's token expires 15 minutes after it is issued

  Scenario: A valid token lets the user set a new password and log in
    Given a valid, unexpired reset token was issued for "user@example.com"
    When the user submits a new password that meets the password policy
    Then the password is updated
    And the user can log in with the new password

  Scenario: The previous password stops working after a successful reset
    Given the user has completed a password reset
    When the user attempts to log in with their previous password
    Then the login is rejected

  # --- RED: negative validations (what must never happen) ---

  Scenario: An expired token never grants access
    Given a reset token was issued for "user@example.com" 16 minutes ago
    When the user submits a new password with that token
    Then the request is rejected as expired
    And the account password is unchanged

  Scenario: A token cannot be used twice
    Given a reset token that has already been used successfully
    When the user submits a new password with that same token
    Then the request is rejected as already used
    And the account password is unchanged

  Scenario: A new password that violates the policy is rejected
    Given a valid, unexpired reset token was issued for "user@example.com"
    When the user submits a new password that violates the password policy
    Then the request is rejected with a policy violation
    And the account password is unchanged

  Scenario: Requesting a reset for an unregistered address reveals nothing
    When a password reset is requested for "stranger@example.com"
    Then the response is identical to a request for a registered address
    And no reset link is sent
