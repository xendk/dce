DCE
===

Simple command for running commands in a docker container started by
docker-compose.

```shell
Usage: dce [OPTIONS]... COMMAND
Runs COMMAND in docker-compose container.

On first run, asks for the service container to use and saves it to .dce_container next
to the docker-compose.yml file.

Options:
-c, --container SERVICE     use the container of the specified service
                            ignores the .dce_container file for this command
-v, --verbose               print exec'ed command
-h, --help                  print this help and exit
```

Optional, but nice setup
------------------------

* Add `.dce_container` to `$HOME/.gitexcludes`.
* `alias dc=dacker-compose`
* `alias dcd="dce drush"`
