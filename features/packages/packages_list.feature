Feature: UPM Sources - List

  In order to list the current spec source repositories for a local UPM installation
  As a CLI I want to be as objective as possible

  @e2e @packages @list
  Scenario: Display current packages list
    Given I run `bundle exec ../../exe/upm package list`
    Then the output should contain the packages table

  @e2e @packages @list
  Scenario: Invalid parameter
    Given I run `bundle exec ../../exe/upm package list test`
    Then the output should contain "ERROR"
