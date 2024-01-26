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

    context 'if a key already exists' do
      it 'overwrites the old value' do
        key = 'Manon'
        old_value = 'x'
        hash_code = 9
        new_value = 'y'
        
        set_hashes.set(key, old_value)

        expect { set_hashes.set(key, new_value) }.to \
          change(buckets[hash_code], :value)
          .from(old_value)
          .to(new_value)
      end
    end
  end
end
