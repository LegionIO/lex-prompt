# frozen_string_literal: true

require_relative 'prompt/version'
require_relative 'prompt/helpers/template_renderer'
require_relative 'prompt/runners/prompt'
require_relative 'prompt/client'

module Legion
  module Extensions
    module Prompt
      extend Legion::Extensions::Core if defined?(Legion::Extensions::Core)
    end
  end
end
