# Changelog

## [v0.0.1]

Potator (Watara Supervision) as a standalone dynamic core

### Added

- Hot m6502 / memory / GPU / sound `.text` in ITCM; WRAM/regs on DTCM via `dtc_malloc` (no ITCM data).

### Changed

- (none)

### Fixed

- (none)

### Install

**Core**

- Unzip the release archive onto the SD card root (`cores/potator.bin`).
- Place ROMs under `/roms/wsv/` (extension `.wsv`, `.sv` or `.bin`).
- Requires firmware whose ABI matches `SDK_VERSION` in this repository.
