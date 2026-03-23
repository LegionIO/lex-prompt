# frozen_string_literal: true

require 'rspec'
require 'sequel'
require 'json'

DB = Sequel.sqlite

DB.create_table(:prompts) do
  primary_key :id
  String :name, null: false, unique: true, size: 255
  String :description, text: true
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table(:prompt_versions) do
  primary_key :id
  foreign_key :prompt_id, :prompts, null: false
  Integer :version, null: false
  String :template, text: true, null: false
  String :variables_schema, text: true
  String :model_params, text: true
  String :content_hash, size: 64, null: false
  DateTime :created_at
end

DB.create_table(:prompt_tags) do
  primary_key :id
  foreign_key :prompt_id, :prompts, null: false
  String :tag, null: false, size: 100
  foreign_key :version_id, :prompt_versions, null: false
  DateTime :created_at
  unique %i[prompt_id tag]
end

require 'legion/logging'
require 'legion/settings'
require 'legion/cache/helper'
require 'legion/crypt/helper'
require 'legion/data/helper'
require 'legion/json/helper'
require 'legion/transport/helper'

module Legion
  module Extensions
    module Helpers
      module Lex
        include Legion::Logging::Helper
        include Legion::Settings::Helper
        include Legion::Cache::Helper
        include Legion::Crypt::Helper
        include Legion::Data::Helper
        include Legion::JSON::Helper
        include Legion::Transport::Helper
      end
    end

    module Core; end
  end
end

require 'legion/extensions/prompt'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    DB[:prompt_tags].delete
    DB[:prompt_versions].delete
    DB[:prompts].delete
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random
  Kernel.srand config.seed
end
