Feature: Copying ssh keys

  Scenario: Copying keys with command
    Given I'm in the simple project
    And I have a "key1" ssh key
    And I have a "key2" ssh key
    And I have a "test" directory in my ssh directory
    When I run "dce -s 'ls $HOME/.ssh'"
    Then I should see the output
      """
      Installing key1
      Installing key2
      key1
      key2
      """
    And the output of "dce 'cat $HOME/.ssh/*'" should be
      """
      key1 file
      key2 file
      """
