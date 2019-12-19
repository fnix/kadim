# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2019-12-19
### Added
- Generate file inputs for models using ActiveStorage `has_one_attached` and/or `has_many_attached` method. The
  generated code can deal with local disk uploads, direct and resumable uploads to the cloud.
- kadim:scaffold_controller now support all the arguments supported by scaffold_controller.

### Changed
- Rename kadim:host:scaffold_controller to only kadim:scaffold_controller.

## [0.2.3] - 2019-12-11
### Fixes
- Kadim was generating exceptions when there isn't a database, preventing CLI commands from running, including
  `rails db:create`.

## [0.2.2] - 2019-12-07
### Fixes
- Don't override user defined kadim controllers/views.

## [0.2.1] - 2019-11-30
### Fixes
- Kadim was generating HAML views for applications using haml-rails, but the current implementation supports only ERb.

## [0.2.0] - 2019-11-30
### Added
- Generator to host kadim scaffold on main application: `rails generate kadim:host:scaffold_controller ModelName`

## [0.1.2] - 2019-11-26
### Added
- Initializer to include kadim assets in `assets.precompile`. a278718ba5f1ea5150406d069b1ed75085199d5b

## [0.1.1] - 2019-11-26
### Added
- Generator to host base kadim files on main application: `rails generate kadim:host --help`
### Fixed
- Avoid an undefined method when a model constant does not have a table. 68c8681226c90d36e0e0946a30d5d3c97263250e

## [0.1.0] - 2019-11-17
### Birthdate :birthday: :tada:
- Kadim dynamically generates scaffolds for your models!

[Unreleased]: https://github.com/fnix/kadim/compare/v0.2.3...HEAD
[0.2.3]: https://github.com/fnix/kadim/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/fnix/kadim/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/fnix/kadim/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/fnix/kadim/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/fnix/kadim/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/fnix/kadim/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/fnix/kadim/compare/ba4fc7ce0ad5ac51ebe11512d694ebd2db33124d...v0.1.0
