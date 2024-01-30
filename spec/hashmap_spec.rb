# frozen_string_literal: true

require_relative '../lib/hashmap'

describe HashMap do
  describe '#set' do
    subject(:set_hashes) { described_class.new }
    let(:buckets) { set_hashes.instance_variable_get(:@buckets) }

    context 'when the bucket is empty' do
      let(:hash_code) { 11 }

      it 'stores a key value pair as the head of linked list' do
        allow(set_hashes).to receive(:hash).and_return(hash_code)

        key = 'Fred'
        value = 'abc'

        set_hashes.set(key, value)

        expect(buckets[hash_code]).to \
          have_attributes(key: key, value: value)
      end
    end

    context 'when the bucket is not empty' do
      let(:hash_code) { 7 }

      it 'stores the pair at the tail of linked list' do
        allow(set_hashes).to receive(:hash).and_return(hash_code)

        keys = %w[Banana Plantain]
        values = %w[Bread Fried]

        set_hashes.set(keys[0], values[0])

        expect { set_hashes.set(keys[1], values[1]) }.to \
          change(buckets[hash_code], :next_node)
          .from(nil)
          .to be_an_instance_of(Node)
      end
    end

    context 'if a key already exists' do
      let(:hash_code) { 9 }

      it 'overwrites the old value' do
        allow(set_hashes).to receive(:hash).and_return(hash_code)

        key = 'Manon'
        old_value = 'x'
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

        result = get_hashes.get(key)

        expect(result).to be_nil
      end
    end
  end
end
