# Changelog

## [0.2.2] - 2026-03-30

### Changed
- update to rubocop-legion 0.1.7, resolve all offenses

## [0.2.1] - 2026-03-22

### Changed
- Add legion-cache, legion-crypt, legion-data, legion-json, legion-logging, legion-settings, legion-transport as runtime dependencies
- Update spec_helper with real sub-gem helper stubs

## [0.2.0] - 2026-03-20

### Added
- Eval template integration: lex-eval seeds 12 judge prompt templates via Client API on first boot
- Templates tagged `:production` for stable eval pipeline

## [0.1.0] - 2026-03-17

### Added
- `Helpers::TemplateRenderer`: `{{variable}}` interpolation, variable extraction, content hashing
- `Runners::Prompt`: create, update (immutable versioning), get (by version/tag), list, tag, render
- Content hash dedup prevents identical version creation
- Standalone `Client` class
- SQLite-backed storage with prompts, prompt_versions, and prompt_tags tables
