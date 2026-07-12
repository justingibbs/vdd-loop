# gherkin-review.feature
#
# Verification standard for the gherkin-review unit — the skill that reviews a
# .feature file (its Gherkin scenarios and its @eval lines) against
# gherkin-guidelines.md and evaluation-guidelines.md.
#
# Goals (GREEN, ratified 2026-07-12 — see gherkin-review.goals):
#   G1: An author can find and fix what's wrong without rereading the guidelines.
#   G2: Loop-corrupting defects are caught before the coding agent builds.
#   G3: The verdict is meaningful — the review can fail a bad standard.
#
# @eval | E1 | Actionability | 0-5       | ≥4   | An author can fix each finding from its text alone, without opening the guidelines
# @eval | E2 | Signal        | 0-5       | ≥3   | Findings separate must-fix from suggestion and avoid pedantic noise
# @eval | E3 | Grounding     | PASS/FAIL | PASS | Each finding's explanation faithfully represents what the cited guideline section actually says
#
# Layer boundary note: "the cited section exists in the guidelines" is
# deterministic → RED scenario below. "the explanation faithfully represents that
# section" is judgment → E3. A floor of objectivity under a softer quality bar.
#
# @verify-detail | fixtures/manifest.tsv | seeded-defect cases for the Scenario Outline
# @verify-detail | check_validation.py   | mechanical runner for every scenario below
#
# Verification protocol: the skill is executed by an LLM; every assertion is
# mechanical (see @verify-detail). One execution per fixture per verification run.

Feature: Gherkin review
  As an author of a verification standard
  I want my .feature file reviewed against the VDD guidelines
  So that I can trust it as the basis for the agent loop before anything is built

  Background:
    Given the fixture manifest "fixtures/manifest.tsv" lists each seeded defect with its fixture, location, and expected guideline section

  # --- YELLOW: validations ---

  Scenario Outline: A seeded guideline violation is caught, located, and cited
    Given the fixture "<fixture>" seeded with <defect>
    When gherkin-review runs on "<fixture>"
    Then the findings report contains a finding whose location matches the manifest entry
    And that finding cites a guideline section the manifest names for it

    Examples:
      | fixture                            | defect                                                        |
      | fixture-unverifiable-then.feature  | a Then step with no observable, checkable outcome             |
      | fixture-red-no-absence.feature     | a RED scenario asserting only an error, not the absent effect |
      | fixture-malformed-eval.feature     | an @eval line missing its threshold field                     |
      | fixture-compound-scenario.feature  | two unrelated behaviors bundled in one scenario               |
      | fixture-ui-mechanics.feature       | UI selectors and click mechanics leaked into step text        |

  Scenario: A clean standard produces no must-fix findings
    Given the exemplar "examples/password-reset/password-reset.feature"
    When gherkin-review runs on the exemplar
    Then the findings report contains no finding with severity "must-fix"

  Scenario: The skill file conforms to the family format
    Given the built skill file "skills/gherkin-review/SKILL.md"
    Then its frontmatter declares "name" and "description"
    And it contains the sections "Purpose", "Inputs", "Outputs", "Invariants", "Procedure", and "Composes with"

  # --- RED: negative validations ---

  Scenario: The review never modifies the file under review
    Given the SHA-256 checksum of every fixture, the exemplar, and both guideline files is recorded before any review runs
    When gherkin-review runs on every fixture and the exemplar
    Then every recorded checksum is unchanged

  Scenario: The review never cites a guideline section that does not exist
    When gherkin-review runs on every fixture and the exemplar
    Then every guideline section cited in any findings report matches a real heading in "gherkin-guidelines.md" or "evaluation-guidelines.md"
