DCE
===

[![Travis](https://img.shields.io/travis/xendk/dce.svg?style=for-the-badge)](https://travis-ci.org/xendk/dce)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/xendk/dce.svg?style=for-the-badge)](https://codeclimate.com/github/xendk/dce)
[![Issue Count](https://img.shields.io/codeclimate/issues/github/xendk/dce.svg?style=for-the-badge)](https://codeclimate.com/github/xendk/dce)
[![Codecov](https://img.shields.io/codecov/c/github/xendk/dce.svg?style=for-the-badge)](https://codecov.io/gh/xendk/dce)

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

* Add `.dce_container` to `$HOME/.gitexcludes`.
* `alias dc=docker-compose`
* `alias dcd="dce drush"`

Limitations
-----------

DCE currently require the container to have `/bin/sh`.
