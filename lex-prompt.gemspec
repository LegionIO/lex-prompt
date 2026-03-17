# frozen_string_literal: true

require_relative 'lib/legion/extensions/prompt/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-prompt'
  spec.version       = Legion::Extensions::Prompt::VERSION
  spec.authors       = ['Matthew Iverson']
  spec.email         = ['matt@iverson.io']

  spec.summary       = 'Versioned prompt management for LegionIO'
  spec.description   = 'Provides versioned prompt storage with immutable versions, tagged releases, ' \
                       'template rendering, and a playground for testing prompts.'
  spec.homepage      = 'https://github.com/LegionIO/lex-prompt'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.files         = Dir['lib/**/*', 'LICENSE', 'README.md']
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
end
