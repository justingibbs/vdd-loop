# fixture-malformed-eval.feature
#
# Verification standard for the support-reply unit.
# Goal (GREEN): A support agent can send a draft reply that addresses the
#               customer's actual issue in the team's voice.

Feature: Support reply drafting
  As a support agent
  I want a draft reply generated from the ticket
  So that I can respond faster without losing the team's voice

  # @eval | E1 | Empathy | 0-5 | Draft acknowledges the customer's stated frustration before proposing a fix

  Scenario: A draft is produced for an open ticket
    Given an open ticket "TK-882" describing a billing error of "$42.00"
    When a draft reply is generated for "TK-882"
    Then a draft reply is returned
    And the draft references ticket "TK-882"

  Scenario: The draft stays within the length budget
    Given an open ticket "TK-882" describing a billing error of "$42.00"
    When a draft reply is generated for "TK-882"
    Then the draft is 200 words or fewer
