Feature: UPM Sources - Add

  In order to add a new spec source repository to a local UPM installation
  As a CLI I want to be as objective as possible

  @e2e @sources @add
  Scenario: Add a custom source, then display the source list, then remove it, then display the source list
    Given I run `bundle exec ../../exe/upm source add -u https://github.com/abnegate/ruby-upm -n upm` interactively
    Then I wait for interactive output to contain "Synced successfully!"

    When I run `bundle exec ../../exe/upm source list`
    Then I wait for output to contain "| core | https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"
    Then I wait for output to contain "| upm  | https://github.com/abnegate/ruby-upm"

    Then the UPM source file should exist
    And the UPM source file should contain "core=https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"
    And the UPM source file should contain "upm=https://github.com/abnegate/ruby-upm"

  @e2e @sources @add
  Scenario: Add a custom source, missing the name and url
    Given I run `bundle exec ../../exe/upm source add` interactively
    Then I wait for interactive output to contain "failure: URL missing"

  @e2e @sources @add
  Scenario: Add a custom source, missing the name
    Given I run `bundle exec ../../exe/upm source add -u https://github.com/abnegate/ruby-upm` interactively
    Then I wait for interactive output to contain "failure: Name missing"

  @e2e @sources @add
  Scenario: Add a custom source, missing the url
    Given I run `bundle exec ../../exe/upm source add -n test` interactively
    Then I wait for interactive output to contain "failure: URL missing"

  @e2e @sources @add
  Scenario: Add a custom source, with an invalid name
    Given I run `bundle exec ../../exe/upm source add -n core -u https://github.com/abnegate/ruby-upm` interactively
    Then I wait for interactive output to contain "failure: Cannot change the core url spec url via this method"

  @e2e @sources @add
  Scenario: Add a custom source, with an invalid url
    Given I run `bundle exec ../../exe/upm source add -n test -u https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs` interactively
    Then I wait for interactive output to contain "failure: Cannot add the core spec repo url under a different name"

  @e2e @sources @add
  Scenario: Add a custom source, with a non-git url
    Given I run `bundle exec ../../exe/upm source add -n test -u https://google.com` interactively
    Then I wait for interactive output to contain "failure: URL is not a git repository"