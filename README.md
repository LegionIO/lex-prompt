# lex-prompt

Versioned prompt management for LegionIO. Provides immutable versioned prompt storage with tagged releases, variable substitution via ERB, and content-hash deduplication.

## Overview

`lex-prompt` manages LLM prompt templates as first-class versioned artifacts. Prompts have named versions and optional tags (e.g., `stable`, `production`). Updating a prompt with unchanged content is a no-op. Variable substitution uses ERB rendering.

## Installation

```ruby
gem 'lex-prompt'
```

## Usage

```ruby
require 'legion/extensions/prompt'

client = Legion::Extensions::Prompt::Client.new

# Create a prompt
client.create_prompt(
  name: 'code-review',
  template: 'Review this <%= language %> code for bugs:\n\n<%= code %>',
  description: 'Code review prompt',
  model_params: { temperature: 0.2, max_tokens: 1000 }
)
# => { created: true, name: 'code-review', version: 1, prompt_id: 1 }

# Update (creates version 2 only if content changed)
client.update_prompt(
  name: 'code-review',
  template: 'Carefully review this <%= language %> code for bugs and style:\n\n<%= code %>'
)
# => { updated: true, name: 'code-review', version: 2 }

# Tag a specific version
client.tag_prompt(name: 'code-review', tag: 'stable', version: 1)

# Render with variable substitution
client.render_prompt(
  name: 'code-review',
  variables: { language: 'Ruby', code: 'def foo; end' },
  tag: 'stable'
)
# => { rendered: "Review this Ruby code for bugs:\n\ndef foo; end", prompt_version: 1 }

# Retrieve without rendering
client.get_prompt(name: 'code-review', version: 1)

# List all prompts
client.list_prompts
```

## Related Repos

- `lex-eval` — runs evaluation suites; prompts are rendered and passed to evaluators
- `lex-dataset` — versioned input/output pairs used together with prompt templates
- `lex-transformer` — named transform definitions can reference prompt templates by name
- `legion-llm` — LLM execution layer; rendered prompts are passed here for inference

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
