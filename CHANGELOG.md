# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/fnix/kadim/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/fnix/kadim/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/fnix/kadim/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/fnix/kadim/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/fnix/kadim/compare/ba4fc7ce0ad5ac51ebe11512d694ebd2db33124d...v0.1.0
