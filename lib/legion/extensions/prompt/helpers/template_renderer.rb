# frozen_string_literal: true

require 'openssl'

module Legion
  module Extensions
    module Prompt
      module Helpers
        module TemplateRenderer
          module_function

          def render(template, variables: {})
            result = template.dup
            variables.each { |key, val| result.gsub!("{{#{key}}}", val.to_s) }
            result
          end

          def extract_variables(template)
            template.scan(/\{\{(\w+)\}\}/).flatten.uniq
          end

          def content_hash(template, model_params = {})
            payload = "#{template}|#{model_params.sort}"
            OpenSSL::Digest.new('SHA256').hexdigest(payload)
          end
        end
      end
    end
  end
end
