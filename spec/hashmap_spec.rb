# frozen_string_literal: true

require_relative '../lib/hashmap'

describe HashMap do
  describe '#set' do
    subject(:set_hashes) { described_class.new }

    let(:buckets) { set_hashes.instance_variable_get(:@buckets) }
    
    it 'stores a key value pair as a Node item in the corresponding bucket' do
      key = 'Fred'
      value = 'abc'
      hash_code = 11

      set_hashes.set(key, value)

      expect(buckets[hash_code]).to \
        have_attributes(:key => key, :value => value)
    end
  end
end
