@user @user_create
Feature: Ernest user create

  Background:
    Given I setup ernest with target "https://ernest.local"

  Scenario: User creates a user
    Given I'm logged in as "john" / "secret123"
    And the user "jane" does not exist
    When I run ernest with "user create jane secret123"
    Then the output should contain "You're not allowed to perform this action, please contact your administrator."

  Scenario: Admin creates a user
    Given I'm logged in as "admin" / "secret123"
    And the user "john" does not exist
    When I run ernest with "user create john secret123"
    Then the output should contain "User created"

  Scenario: Admin creates a duplicate user
    Given I'm logged in as "admin" / "secret123"
    And the user "john" exists
    When I run ernest with "user create john secret123"
    Then the output should contain "Specified user already exists, please choose a different one."

  Scenario: Admin creates a user with no name
    Given I'm logged in as "admin" / "secret123"
    And the user "john" does not exist
    When I run ernest with "user create"
    Then the output should contain "Please specify a username and password."

  Scenario: Admin creates a user with no password
    Given I'm logged in as "admin" / "secret123"
    And the user "john" does not exist
    When I run ernest with "user create john"
    Then the output should contain "Please specify a password."

  Scenario: Admin creates a user with a username containing invalid characters
    Given I'm logged in as "admin" / "secret123"
    And the user "test^creation" does not exist
    When I run ernest with "user create test^creation secret123"
    Then The output should contain "Username can only contain the following characters: a-z 0-9 @._-"

  Scenario: Admin creates a user with a password less than the minimum length
    Given I'm logged in as "admin" / "secret123"
    And the user "test_creation" does not exist
    When I run ernest with "user create test_creation secret"
    Then The output should contain "Minimum password length is 8 characters"

  Scenario: Admin creates a user with a password containing invalid characters
    Given I'm logged in as "admin" / "secret123"
    And the user "test_creation" does not exist
    When I run ernest with "user create test_creation secret^123"
    Then The output should contain "Password can only contain the following characters: a-z 0-9 @._-"

  Scenario: Unauthenticated user creates a user
    Given I logout
    When I run ernest with "user create john secret123"
    Then the output should contain "You're not allowed to perform this action, please log in."
