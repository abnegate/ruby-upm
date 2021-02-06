Feature: UPM Sources - Remove

  In order to remove a spec source repository to a local UPM installation
  As a CLI I want to be as objective as possible

  @e2e @sources
  Scenario: Sync all spec source repos
    Given I run `bundle exec ../../exe/upm source sync` interactively
    Then I wait for interactive output to contain "Synced successfully!"

    Then the UPM source file should exist
    And the UPM source file should contain "core=https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"