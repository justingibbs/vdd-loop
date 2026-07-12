# fixture-ui-mechanics.feature
#
# Verification standard for the newsletter-signup unit.
# Goal (GREEN): A visitor can subscribe to the newsletter in one step.

Feature: Newsletter signup
  As a site visitor
  I want to subscribe to the newsletter
  So that I receive product updates by email

  Scenario: A visitor subscribes with a valid address
    Given the visitor is on the homepage
    When the visitor clicks the "#newsletter-input" field, types "sam@example.com", and clicks the "#subscribe-btn" button
    Then a subscription confirmation is shown for "sam@example.com"

  Scenario: A subscribed address receives the next newsletter
    Given "sam@example.com" is a confirmed subscriber
    When the next newsletter is sent
    Then "sam@example.com" receives it
