@environment
Feature: Ernest environment

  Background:
    Given I setup ernest with target "https://ernest.local"
  
  Scenario: User calls environment subcommand
    Given I'm logged in as "john" / "secret"
    When I run ernest with "environment"
    Then the output should contain "list"
    And the output should contain "info"
    And the output should contain "create"
    And the output should contain "update"
    And the output should contain "delete"

  Scenario: Unauthenticated user calls environment subcommand
    Given I logout
    When I run ernest with "environment"
    Then the output should contain "list"
    And the output should contain "info"
    And the output should contain "create"
    And the output should contain "update"
    And the output should contain "delete"
