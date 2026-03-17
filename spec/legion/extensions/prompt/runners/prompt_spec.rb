# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Extensions::Prompt::Runners::Prompt do
  let(:client) { Legion::Extensions::Prompt::Client.new(db: DB) }

  describe '#create_prompt' do
    it 'creates a prompt with version 1' do
      result = client.create_prompt(name: 'test', template: 'Hello {{name}}')
      expect(result[:created]).to be true
      expect(result[:version]).to eq(1)
      expect(result[:name]).to eq('test')
    end
  end

  describe '#update_prompt' do
    before { client.create_prompt(name: 'test', template: 'v1') }

    it 'creates a new version when template changes' do
      result = client.update_prompt(name: 'test', template: 'v2')
      expect(result[:updated]).to be true
      expect(result[:version]).to eq(2)
    end

    it 'rejects duplicate content' do
      result = client.update_prompt(name: 'test', template: 'v1')
      expect(result[:updated]).to be false
      expect(result[:reason]).to eq('no_change')
    end

    it 'returns error for unknown prompt' do
      result = client.update_prompt(name: 'missing', template: 'x')
      expect(result[:error]).to eq('not_found')
    end
  end

  describe '#get_prompt' do
    before do
      client.create_prompt(name: 'test', template: 'v1')
      client.update_prompt(name: 'test', template: 'v2')
    end

    it 'returns latest version by default' do
      result = client.get_prompt(name: 'test')
      expect(result[:version]).to eq(2)
      expect(result[:template]).to eq('v2')
    end

    it 'returns specific version' do
      result = client.get_prompt(name: 'test', version: 1)
      expect(result[:version]).to eq(1)
      expect(result[:template]).to eq('v1')
    end

    it 'returns error for unknown prompt' do
      result = client.get_prompt(name: 'missing')
      expect(result[:error]).to eq('not_found')
    end

    it 'returns by tag' do
      client.tag_prompt(name: 'test', tag: 'production', version: 1)
      result = client.get_prompt(name: 'test', tag: 'production')
      expect(result[:version]).to eq(1)
    end
  end

  describe '#list_prompts' do
    it 'returns all prompts with latest version' do
      client.create_prompt(name: 'a', template: 'template_a')
      client.create_prompt(name: 'b', template: 'template_b')
      result = client.list_prompts
      expect(result.size).to eq(2)
      expect(result.map { |p| p[:name] }).to contain_exactly('a', 'b')
    end
  end

  describe '#tag_prompt' do
    before { client.create_prompt(name: 'test', template: 'v1') }

    it 'tags a specific version' do
      result = client.tag_prompt(name: 'test', tag: 'stable', version: 1)
      expect(result[:tagged]).to be true
      expect(result[:tag]).to eq('stable')
    end

    it 'tags latest version when no version specified' do
      client.update_prompt(name: 'test', template: 'v2')
      result = client.tag_prompt(name: 'test', tag: 'latest')
      expect(result[:version]).to eq(2)
    end

    it 'returns error for unknown prompt' do
      result = client.tag_prompt(name: 'missing', tag: 'x')
      expect(result[:error]).to eq('not_found')
    end
  end

  describe '#render_prompt' do
    before { client.create_prompt(name: 'greeting', template: 'Hello {{name}}') }

    it 'renders template with variables' do
      result = client.render_prompt(name: 'greeting', variables: { name: 'Alice' })
      expect(result[:rendered]).to eq('Hello Alice')
    end

    it 'returns error for unknown prompt' do
      result = client.render_prompt(name: 'missing', variables: {})
      expect(result[:error]).to eq('not_found')
    end
  end
end
