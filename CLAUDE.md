# lex-prompt

**Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## What Is This Gem?

Versioned prompt management for LegionIO. Stores LLM prompt templates with immutable versioning, tagged releases, and ERB variable substitution. Content-hash deduplication prevents spurious version creation.

**Gem**: `lex-prompt`
**Version**: 0.1.0
**Namespace**: `Legion::Extensions::Prompt`

## File Structure

```
lib/legion/extensions/prompt/
  version.rb
  helpers/
    template_renderer.rb  # ERB rendering + content_hash(template, model_params)
  runners/
    prompt.rb             # create_prompt, update_prompt, get_prompt, list_prompts,
                          # tag_prompt, render_prompt
  client.rb
spec/
  (4 spec files)
```

## Key Design Decisions

- Content hashing (SHA256 of template + model_params) prevents duplicate versions — `update_prompt` returns `{ updated: false, reason: 'no_change' }` on identical content
- Tags are upserted (`insert_conflict`) — re-tagging an existing tag updates the target version
- `render_prompt` calls `get_prompt` first; returns the error hash unmodified if prompt/version not found
- `model_params` is serialized to JSON for storage, deserialized with symbol keys on retrieval
- The runner uses `@db` (Sequel database handle) injected via the Client constructor

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```
