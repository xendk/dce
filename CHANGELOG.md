# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 3.0.0 - [Unreleased]

### Changed
- Tooling updated to Ruby 3.3.

### Removed
- Support for Ruby 2.7, 3.0 and 3.1.

## [2.0.0] - 2023-03-01

### Changed
- Use docker compose (without `-`).

## [1.2.3] - 2023-01-03

Publishing changes.

## [1.2.2] - 2023-01-03

### Fixed
- Check for `services` key in docker-compose file rather than `version`. 

## [1.2.1] - 2021-10-01

### Fixed
- Support YAML aliases in docker-compose file.

## [1.2.0] - 2021-08-16

### Fixed
- Support `.yaml` files as well as `.yml`.

## [1.1.1] - 2020-06-03

CI related fixes.

## [1.1.0] - 2020-02-21

### Added
- `-l`/`--list-containers` to list available containers.

## [1.0.3] - 2020-02-21

CI and publishing fixes.

## 1.0.1 and 1.0.2 -  2020-02-20

Minor release fixes.

## 1.0.0 - 2020-02-20

First version on Rubygems.

## 0.0.0 - 2018-01-16

### Added
- Installation documentation.
- `--dry-run` to display the docker command that would be run.
- `-?`/`--print-service` to print container being used.
- `-c`/`--container` to replace the used container.
- `-v`/`--verbose` to print command being run.
- `-h`/`--help` to print help.

[Unreleased]: https://github.com/xendk/dce/compare/2.0.0...HEAD
[2.0.0]: https://github.com/xendk/dce/compare/1.2.3...2.0.0
[1.2.3]: https://github.com/xendk/dce/compare/1.2.2...1.2.3
[1.2.2]: https://github.com/xendk/dce/compare/1.2.1...1.2.2
[1.2.1]: https://github.com/xendk/dce/compare/1.2.0...1.2.1
[1.2.0]: https://github.com/xendk/dce/compare/1.1.1...1.2.0
[1.1.1]: https://github.com/xendk/dce/compare/1.0.3...1.1.1
[1.0.3]: https://github.com/xendk/dce/releases/tag/1.0.3
