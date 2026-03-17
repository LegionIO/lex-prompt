# frozen_string_literal: true

module Legion
  module Extensions
    module Prompt
      class Client
        include Runners::Prompt

        def initialize(db: nil, **opts)
          @db   = db
          @opts = opts
        end
      end
    end
  end
end
