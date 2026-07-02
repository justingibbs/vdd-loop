# dispute-summary.feature
#
# The Validation layer for the dispute-summary feature.
# Output of Goal Storming's YELLOW (validation) and RED (negative
# validation) cards.
#
# Goal (GREEN): A dispute reviewer can grasp what a dispute is about,
#               and decide how to route it, without opening the full case file.
#
# This feature ALSO has an Evaluation layer, because summary *quality*
# (faithfulness, neutrality, completeness) cannot be captured by a
# deterministic assertion. Those judgment-based criteria live in
# /evaluations/dispute-summary.rubric.md. This file covers only what a
# deterministic check can confirm — the guardrails around the summary,
# not its quality.

Feature: Dispute summary
  As a dispute reviewer
  I want a short, neutral brief of each dispute
  So that I can understand and route it without reading the full case file

  Background:
    Given a dispute "D-4471" exists with a customer complaint, a transaction
      record, and correspondence

  # --- YELLOW: validations (deterministic guardrails on the output) ---

  Scenario: A summary is produced for a complete dispute
    When a summary is generated for dispute "D-4471"
    Then a summary is returned
    And it references the dispute id "D-4471"

  Scenario: The summary stays within the length budget
    When a summary is generated for dispute "D-4471"
    Then the summary is 150 words or fewer

  # --- RED: negative validations (what must never happen) ---

  Scenario: The summary never leaks a full card number
    When a summary is generated for dispute "D-4471"
    Then the summary contains no full Primary Account Number
    And any card reference is masked to the last 4 digits

  Scenario: No summary is produced from incomplete input
    Given a dispute "D-9002" that is missing its transaction record
    When a summary is generated for dispute "D-9002"
    Then no summary is returned
    And the caller is told which required input is missing

  # Note on the boundary between layers:
  #   "150 words or fewer"        → deterministic → lives here (YELLOW).
  #   "concise, no filler"        → judgment      → lives in the rubric (BLUE).
  # The length cap is a floor of objectivity under the softer quality bar;
  # both exist, and they check different things.
