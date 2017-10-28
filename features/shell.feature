Feature: Opening a shell

  Scenario: Open sh
    Given I'm in the shell project
    When I run "dce"
    Then I should see the output
      """
      This is /bin/sh
      """

  Scenario: Open bash
    Given I'm in the shell project
    And it has bash installed
    When I run "dce"
    Then I should see the output
      """
      This is /bin/bash
      """
      
  Scenario: Open fish
    Given I'm in the shell project
    And it has fish installed
    When I run "dce"
    Then I should see the output
      """
      This is /usr/bin/fish
      """
