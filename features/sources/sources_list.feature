Feature: UPM Sources - List

  In order to list the current spec source repositories for a local UPM installation
  As a CLI I want to be as objective as possible

  @e2e @sources @list
  Scenario: Display current source list
    Given I run `bundle exec ../../exe/upm source list`

    Then I wait for output to contain "| core | https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs |"

    Then the UPM source file should exist
    And the UPM source file should contain "core=https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"

  @e2e @sources @list
  Scenario: Add a custom source, then display the source list
    Given I run `bundle exec ../../exe/upm source add -u https://github.com/abnegate/ruby-upm -n upm` interactively
    Then I wait for interactive output to contain "Synced successfully!"

    When I run `bundle exec ../../exe/upm source list`
    Then I wait for output to contain "| core | https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"
    Then I wait for output to contain "| upm  | https://github.com/abnegate/ruby-upm"

    Then the UPM source file should exist
    And the UPM source file should contain "core=https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"
    And the UPM source file should contain "upm=https://github.com/abnegate/ruby-upm"

  @e2e @sources @list
  Scenario: Add a custom source, then display the source list, then remove it, then display the source list
    Given I run `bundle exec ../../exe/upm source add -u https://github.com/abnegate/ruby-upm -n upm` interactively
    Then I wait for interactive output to contain "Synced successfully!"

    When I run `bundle exec ../../exe/upm source list`
    Then I wait for output to contain "| core | https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"
    Then I wait for output to contain "| upm  | https://github.com/abnegate/ruby-upm"

    Then the UPM source file should exist
    And the UPM source file should contain "core=https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"
    And the UPM source file should contain "upm=https://github.com/abnegate/ruby-upm"

    When I run `bundle exec ../../exe/upm source remove upm` interactively
    Then I wait for output to contain "Synced successfully!"

    When I run `bundle exec ../../exe/upm source list`
    Then I wait for output to contain "| core | https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"

    Then the UPM source file should exist
    And the UPM source file should contain "core=https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"
    And the UPM source file should not contain "upm=https://github.com/abnegate/ruby-upm"

  @e2e @sources @list
  Scenario: Invalid parameter
    Given I run `bundle exec ../../exe/upm source list test`
    Then the output should contain "ERROR"
