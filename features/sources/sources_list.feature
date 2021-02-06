Feature: UPM Sources - List

  In order to list the current sources for a UPM installation
  As a CLI I want to be as objective as possible

  @e2e @sources @announce-output
  Scenario: Display current source list
    Given I run `bundle exec ../../exe/upm source list`

    Then I wait for output to contain "| core | https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs |"

    Then the UPM source file should exist
    And the UPM source file should contain "core=https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"

  @e2e @sources @announce-output
  Scenario: Add a custom source, then display the source list
    Given I run `bundle exec ../../exe/upm source add -u https://github.com/abnegate/ruby-upm -n upm` interactively
    Then I wait for interactive output to contain "Synced successfully!"

    When I run `bundle exec ../../exe/upm source list`
    Then I wait for output to contain "| core | https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"
    Then I wait for output to contain "| upm  | https://github.com/abnegate/ruby-upm"

    Then the UPM source file should exist
    And the UPM source file should contain "core=https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"
    And the UPM source file should contain "upm=https://github.com/abnegate/ruby-upm"
