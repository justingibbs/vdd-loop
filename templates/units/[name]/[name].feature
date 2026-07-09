# [name].feature
#
# Create as units/<name>/<name>.feature and fill in. This is the complete
# verification standard for the unit: Validation scenarios (YELLOW + RED) and
# Evaluation criteria (@eval lines, BLUE). Write against gherkin-guidelines.md
# for the scenarios and evaluation-guidelines.md for the @eval lines.
#
# Goal (GREEN): [the one-line goal this unit proves]
#
# --- Evaluation criteria (@eval lines) ---
# Include only for goals that need judgment to assess (BLUE cards).
# Remove this block entirely if the unit is purely deterministic.
#
# @eval | E1 | [Name] | [0-5 | PASS/FAIL] | [≥N | PASS] | [one sentence: what is judged]
# @eval-detail | [name].rubric.md  ← add only when criteria need anchor descriptions
#
# Reminders (see gherkin-guidelines.md): one behavior per scenario · declarative,
# not imperative · state-based Givens · third person, present tense · strict
# Given→When→Then · observable Then outcomes · realistic data · RED scenarios
# must assert the forbidden effect did NOT occur, not just that an error appeared.

Feature: [Behavior area]
  As a [role]
  I want [capability]
  So that [outcome / the goal above]

  Background:
    Given [shared setup used by more than one scenario — omit if not needed]

  # --- YELLOW: validations (prove the goal) ---

  Scenario: [one positive behavior]
    Given [state]
    When [action]
    Then [observable outcome]

  # --- RED: negative validations (what must never happen) ---

  Scenario: [one thing that must never happen]
    Given [state]
    When [action]
    Then [the request is rejected / the action is refused]
    And [the forbidden effect did not occur]

  # --- Input variation on IDENTICAL behavior (use only when warranted) ---

  Scenario Outline: [behavior] for <case>
    Given [state for <case>]
    When [action]
    Then [outcome for <result>]

    Examples:
      | case | result |
      | ...  | ...    |
