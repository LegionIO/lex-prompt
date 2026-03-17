# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Extensions::Prompt::Client do
  it 'includes Prompt runner' do
    client = described_class.new(db: DB)
    expect(client).to respond_to(:create_prompt)
    expect(client).to respond_to(:get_prompt)
    expect(client).to respond_to(:list_prompts)
    expect(client).to respond_to(:render_prompt)
  end
end
