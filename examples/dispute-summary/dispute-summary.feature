# dispute-summary.feature
#
# Verification standard for the dispute-summary unit.
# Validation scenarios come from Goal Storming's YELLOW (positive) and RED
# (negative) cards. Evaluation criteria are inline as @eval lines below.
#
# Goal (GREEN): A dispute reviewer can grasp what a dispute is about,
#               and decide how to route it, without opening the full case file.
#
# --- Evaluation criteria (@eval lines) ---
# Summary *quality* (faithfulness, neutrality, completeness) requires judgment
# and cannot be captured by a deterministic assertion. These @eval lines are the
# Evaluation layer for this unit; anchor descriptions are in dispute-summary.rubric.md.
#
# @eval | E1 | Faithfulness      | 0-5       | ≥4   | Summary uses only facts present in the source case file
# @eval | E2 | Neutrality        | PASS/FAIL | PASS | Summary attributes claims without assigning blame or verdict
# @eval | E3 | Routing facts     | 0-5       | ≥4   | Summary contains what, amount, date, and customer reason
# @eval | E4 | Conciseness       | 0-5       | ≥3   | No filler or restatement beyond what aids routing
# @eval-detail | dispute-summary.rubric.md
#
# Note on the boundary between layers:
#   "150 words or fewer"   → deterministic → YELLOW scenario below
#   "concise, no filler"   → judgment      → @eval E4 above
# The length cap is a floor of objectivity under the softer quality bar;
# both exist, and they check different things.

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
