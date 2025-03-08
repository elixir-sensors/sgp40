# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.7] - 2025-03-09

**Changed**

- REUSE Compliance
- Make pure library and support >1 sensor
- Bump dependencies, CI, and update Dialyzer

## [0.1.6] - 2024-01-17

**Changed**

- Relax circuits_i2c dependency to allow v2.0

## [0.1.5] - 2023-02-18

Fix Elixir code based on warnings. Nothing will be changed at the high level.

**Changed**

- Use Application.compile_env/3 instead of Application.get_env/3
- Define mocks at compile time instead of at runtime

## [0.1.4] - 2021-11-26

**Improvement**

- Relax circuits_i2c dependency to allow v1.0
- Do not use `i2c_server`

## [0.1.3] - 2021-06-25

### Fixed

- Hex Github action

## [0.1.2] - 2021-06-23

### Changed

- Refactor Mox-related code in CommTest
- Simplify CI Github action

### Added

- Hex Github action

## [0.1.1] - 2021-06-16

### Added

- Github action as CI
- CI badge and Hex badge in README.md

### Changed

- Use `Access` instead of `Keyword.get/2` following advice in [Good and Bad Elixir | keathley.io](https://keathley.io/blog/good-and-bad-elixir.html)
- Rename `*_accumulator` to `*_reducer`
- Simplify `SGP40.Transport.I2C` without using `apply`
- Refactor Mox-related test code

### Removed

- Unused `SGP40.I2C.Stub`
- Default gen server name `__MODULE__`
- Pattern matching for `args` in `SGP40.VocIndex.handle_call({:set_tuning_params, args}, _, state)`

### Fixed

- Correct typespec for `SGP40.measure/1`

## [0.1.0] - 2021-06-13

### Added

- Initial release

[Unreleased]: https://github.com/elixir-sensors/sgp40/compare/v0.1.7...HEAD
[0.1.7]: https://github.com/elixir-sensors/sgp40/compare/v0.1.6...v0.1.7
[0.1.6]: https://github.com/elixir-sensors/sgp40/compare/v0.1.5...v0.1.6
[0.1.5]: https://github.com/elixir-sensors/sgp40/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/elixir-sensors/sgp40/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/elixir-sensors/sgp40/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/elixir-sensors/sgp40/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/elixir-sensors/sgp40/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/elixir-sensors/sgp40/releases/tag/v0.1.0
