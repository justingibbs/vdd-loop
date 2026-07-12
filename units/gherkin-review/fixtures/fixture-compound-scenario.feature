# fixture-compound-scenario.feature
#
# Verification standard for the profile-update unit.
# Goal (GREEN): A user can change how their name appears, and the change is
#               accountable after the fact.

Feature: Profile update
  As a registered user
  I want to update my display name
  So that my profile reflects how I want to be seen

  Scenario: Updating the display name updates the profile and the audit log
    Given a registered user "sam@example.com" with display name "Sam"
    When the user updates their display name to "Samantha"
    Then the profile shows the display name "Samantha"
    When an administrator exports the audit log
    Then the export contains the display name change for "sam@example.com"
