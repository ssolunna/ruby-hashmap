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

  describe '#get' do
    subject(:get_hashes) { described_class.new }

    context 'when key is found' do
      let(:key) { 'Language' }
      let(:hash_code) { '8' }
      let(:value) { 'Ruby' }
      let(:node) { double('Node', key: key, value: value) }

      it 'returns its value' do
        allow(get_hashes).to receive(:hash).and_return(hash_code)
        allow(get_hashes).to receive(:buckets).and_return(node)

        result = get_hashes.get(key)

        expect(result).to eq(value)
      end
    end

    context 'when key is not found' do
      it 'returns nil' do
        key = 'Project'
        value = 'Odin'
        hash_code = '9'

        result = get_hashes.get(key)

        expect(result).to be_nil
      end
    end
  end
end
