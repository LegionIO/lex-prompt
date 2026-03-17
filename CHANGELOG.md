# Changelog

## [0.1.0] - 2026-03-17

### Added
- `Helpers::TemplateRenderer`: `{{variable}}` interpolation, variable extraction, content hashing
- `Runners::Prompt`: create, update (immutable versioning), get (by version/tag), list, tag, render
- Content hash dedup prevents identical version creation
- Standalone `Client` class
- SQLite-backed storage with prompts, prompt_versions, and prompt_tags tables
