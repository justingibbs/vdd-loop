# fixture-unverifiable-then.feature
#
# Verification standard for the order-confirmation unit.
# Goal (GREEN): A customer knows their order was received without contacting support.

Feature: Order confirmation email
  As a customer who placed an order
  I want a confirmation email after checkout
  So that I know my order was received

  Scenario: A confirmation email is sent after checkout
    Given a customer completes checkout for order "ORD-2214"
    When the order is confirmed
    Then everything works as expected

  Scenario: The confirmation references the order number
    Given a customer completes checkout for order "ORD-2214"
    When the confirmation email is delivered
    Then the email subject contains "ORD-2214"
