# feature-name.feature — TEMPLATE
#
# Copy to /features/<feature-name>.feature and fill in. This is the Validation
# layer: deterministic scenarios that either pass or fail. Scenarios come from
# Goal Storming's YELLOW (positive) and RED (negative) cards.
#
# Write it against gherkin-guidelines.md. Keep this header (it ties the file to
# its goal); delete the instructional lines below once filled in.
#
# Goal (GREEN): [the one-line goal this feature proves]
# Rubric:       [none | evaluations/<feature-name>.rubric.md]
#
# Reminders (see gherkin-guidelines.md): one behavior per scenario · declarative,
# not imperative · state-based Givens · third person, present tense · strict
# Given→When→Then · observable Then outcomes · realistic data · RED scenarios must
# assert the forbidden effect did NOT occur, not just that an error appeared.

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
