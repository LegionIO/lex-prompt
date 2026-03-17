# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Extensions::Prompt do
  it 'has a version number' do
    expect(Legion::Extensions::Prompt::VERSION).not_to be_nil
  end

  it 'version is a string' do
    expect(Legion::Extensions::Prompt::VERSION).to be_a(String)
  end
end
