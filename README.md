DCE
===

[![Code Climate](https://codeclimate.com/github/xendk/dce/badges/gpa.svg)](https://codeclimate.com/github/xendk/dce)
[![Issue Count](https://codeclimate.com/github/xendk/dce/badges/issue_count.svg)](https://codeclimate.com/github/xendk/dce)

Simple command for running commands in a docker container started by
docker-compose.

```shell
Usage: dce [OPTIONS]... COMMAND
Runs COMMAND in docker-compose container.

On first run, asks for the service container to use and saves it to .dce_container next
to the docker-compose.yml file.

Options:
-c, --container SERVICE     use the container of the specified service
replaces the selected container in the .dce_container
-v, --verbose               print exec'ed command
-?, --print-service         print the service saved
-h, --help                  print this help and exit
```

Optional, but nice, setup
-------------------------

* Add `.dce_container` to `$HOME/.gitexcludes`.
* `alias dc=docker-compose`
* `alias dcd="dce drush"`
* `alias dcs="dce 'sh -c \"if [ -e /bin/bash ]; then /bin/bash; else /bin/sh;fi\"'"`
