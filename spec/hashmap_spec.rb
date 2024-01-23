# frozen_string_literal: true

require_relative '../lib/hashmap'

describe HashMap do
  describe '#hash' do
    subject(:hashmap) { described_class.new }

    it 'returns the hash code of a given string (key)' do
      hash_code = 9
      key = 'Manon'
      result = hashmap.hash(key)
      expect(result).to eq(hash_code)
    end
  end
end
