@destroy
Feature: Ernest destroy

  Background:
    Given I setup ernest with target "https://ernest.local"

  Scenario: User with project role destroys an environment
    Given I'm logged in as "john" / "secret"
    And the user "john" has "<role>" role on project "myapp"
    And the user "john" has no role on environment "dev" in project "myapp"
    When I run ernest with "destroy myapp dev"
    Then the output should contain "<output>"

    Examples:
      |role|output|
      |owner|Environment destroyed|
      |reader|You're not allowed to perform this action, please contact your administrator.|

  Scenario: User with environment role destroys an environment
    Given I'm logged in as "john" / "secret"
    And the user "john" has "<role>" role on environment "dev" in project "myapp"
    And the user "john" has no role on project "myapp"
    When I run ernest with "destroy myapp dev"
    Then the output should contain "<output>"

    Examples:
      |role|output|
      |owner|Environment destroyed|
      |reader|You're not allowed to perform this action, please contact your administrator.|

  Scenario: User with both project and environment role destroys an environment
    Given I'm logged in as "john" / "secret"
    And the user "john" has "<prj-role>" role on project "myapp"
    And the user "john" has "<env-role>" role on environment "dev" in project "myapp"
    When I run ernest with "destroy myapp dev"
    Then the output should contain "<output>"

    Examples:
      |prj-role|env-role|output|
      |owner|owner|Environment destroyed|
      |owner|reader|You're not allowed to perform this action, please contact your administrator.|
      |reader|owner|Environment destroyed|
      |reader|reader|You're not allowed to perform this action, please contact your administrator.|

  Scenario: User without role destroys an environment
    Given I'm logged in as "john" / "secret"
    And the user "john" has no role on project "myapp"
    And the user "john" has no role on environment "dev" in project "myapp"
    When I run ernest with "destroy myapp dev"
    Then the output should contain "Environment does not exist"

  Scenario: User destroys an environment which does not exist
    Given I'm logged in as "john" / "secret"
    And the project "myapp" exists
    When I run ernest with "destroy myapp fakeEnvironment"
    Then the output should contain "Specified environment does not exist, please choose a different one."

  Scenario: User destroys an environment with no name
    Given I'm logged in as "john" / "secret"
    When I run ernest with "destroy"
    Then the output should contain "help"

  Scenario: Admin destroys an environment
    Given I'm logged in as "admin" / "secret"
    And the environment "dev" exists in project "myapp"
    When I run ernest with "destroy myapp dev"
    Then the output should contain "Environment destroyed"

  Scenario: Unuthenticated user deletes an environment
    Given I logout
    When I run ernest with "destroy myapp dev"
    Then the output should contain "You're not allowed to perform this action, please log in."
