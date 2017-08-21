Feature: Run commands

  Scenario: Simple command
    Given I'm in the simple project
    When I run "dce ls --color=never"
    Then I should see the output
      """
      bin    etc    lib    mnt    root   sbin   sys    usr
      dev    home   media  proc   run    srv    tmp    var
      """

  Scenario: Pipes in container
    Given I'm in the simple project
    # Using /etc/issue to check that it's really running in the container.
    When I run "dce 'echo test | cat - /etc/issue'"
    Then I should see the output
      """
      test
      Welcome to Alpine Linux 3.6
      Kernel \r on an \m (\l)

      """

  Scenario: Piping into ontainer
    Given I'm in the simple project
    When I run "echo test | dce 'cat'"
    Then I should see the output
      """
      test
      """

  Scenario: Piping out of ontainer
    Given I'm in the simple project
    When I run "dce 'echo test' | cat -"
    Then I should see the output
      """
      test
      """
