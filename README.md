DCE
===

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/xendk/dce/Run%20tests%20and%20publish?style=for-the-badge)
[![Codecov](https://img.shields.io/codecov/c/github/xendk/dce.svg?style=for-the-badge)](https://codecov.io/gh/xendk/dce)

[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/xendk/dce?style=for-the-badge)](https://codeclimate.com/github/xendk/dce)
[![Code Climate issues](https://img.shields.io/codeclimate/issues/xendk/dce?style=for-the-badge)](https://codeclimate.com/github/xendk/dce)
[![Code Climate technical debt](https://img.shields.io/codeclimate/tech-debt/xendk/dce?style=for-the-badge)](https://codeclimate.com/github/xendk/dce)

[![Gem](https://img.shields.io/gem/v/dce.svg?style=for-the-badge)](https://rubygems.org/gems/dce)
[![Gem](https://img.shields.io/gem/dt/dce.svg?style=for-the-badge)](https://rubygems.org/gems/dce)

Simple command for running shell commands in a docker container
started by docker-compose.

Install
-------------------------
Run `gem install dce`. If you only want to install it for your own user, use the `--user-install` flag.

Usage
-------------------------
```shell
Usage: dce [OPTIONS]... COMMAND
Runs COMMAND in docker-compose container.

On first run, asks for the service container to use and saves it to .dce_container next
to the docker-compose.yml file.

If no command given, opens a shell.

Options:
-c, --container SERVICE     use the container of the specified service
replaces the selected container in the .dce_container
-v, --verbose               print exec'ed command
-n, --dry-run               only print exec'ed command, don't run
-?, --print-service         print the service saved
-l, --list-containers       print the containers available
-h, --help                  print this help and exit
```

Optional, but nice, setup
-------------------------

* Add `.dce_container` to `$HOME/.config/git/ignore`.
* `alias dc=docker-compose`
* `alias dcd="dce drush"`

Limitations
-----------

DCE currently require the container to have `/bin/sh`.

Development
-----------

To run tests, you'll need docker-compose (obviously), and cucumber:

``` shell
gem install --user-install cucumber
```

Use `make test` to run the test-suite.
