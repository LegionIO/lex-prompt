# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Extensions::Prompt::Helpers::TemplateRenderer do
  describe '.render' do
    it 'replaces variables in template' do
      result = described_class.render('Hello {{name}}, you are {{role}}', variables: { name: 'Alice', role: 'admin' })
      expect(result).to eq('Hello Alice, you are admin')
    end

    it 'leaves unreplaced variables as-is' do
      result = described_class.render('Hello {{name}}', variables: {})
      expect(result).to eq('Hello {{name}}')
    end

    it 'handles multiple occurrences of the same variable' do
      result = described_class.render('{{x}} and {{x}}', variables: { x: 'hi' })
      expect(result).to eq('hi and hi')
    end
  end

  describe '.extract_variables' do
    it 'returns unique variable names' do
      vars = described_class.extract_variables('{{a}} and {{b}} and {{a}}')
      expect(vars).to eq(%w[a b])
    end

    it 'returns empty array for no variables' do
      vars = described_class.extract_variables('plain text')
      expect(vars).to eq([])
    end
  end

  describe '.content_hash' do
    it 'returns consistent hash for same content' do
      h1 = described_class.content_hash('template', { model: 'x' })
      h2 = described_class.content_hash('template', { model: 'x' })
      expect(h1).to eq(h2)
    end

    it 'changes when template changes' do
      h1 = described_class.content_hash('v1', {})
      h2 = described_class.content_hash('v2', {})
      expect(h1).not_to eq(h2)
    end

    it 'returns a 64-character hex string' do
      hash = described_class.content_hash('test', {})
      expect(hash).to match(/\A[a-f0-9]{64}\z/)
    end
  end
end
