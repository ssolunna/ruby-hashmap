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
      let(:node) { instance_double('Node', key: key, value: value) }

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

  describe '#key?' do
    subject(:key_hashes) { described_class.new }
    let(:node_one) { instance_double('Node', key: 'a', next_node: node_two) }
    let(:node_two) { instance_double('Node', key: 'b', next_node: nil) }
    let(:buckets) { [nil, nil, node_one, nil] }
    let(:hash_code) { 2 }

    before do
      allow(key_hashes).to receive(:hash).and_return(hash_code)
      key_hashes.instance_variable_set(:@buckets, buckets)
    end

    context 'if key exists' do
      it 'returns true' do
        result = key_hashes.key?('b')

        expect(result).to eq(true)
      end
    end

    context 'if key does not exist' do
      it 'returns false' do
        result = key_hashes.key?('c')

        expect(result).to eq(false)
      end
    end
  end

  describe '#remove' do
    subject(:remove_hash_entry) { described_class.new }
    let(:node_one) { instance_double('Node', key: 'x', value: '1', next_node: node_two) }
    let(:node_two) { instance_double('Node', key: 'y', value: '2', next_node: nil) }
    let(:node_zero) { instance_double('Node', key: 'z', value: '3', next_node: node_two) }
    let(:buckets) { [node_zero, node_one, nil, nil] }

    before do
      remove_hash_entry.instance_variable_set(:@buckets, buckets)
      allow(remove_hash_entry).to receive(:hash).and_return(hash_code)
      allow(node_one).to receive(:next_node=)
    end

    context 'if key exists' do
      let(:hash_code) { 1 }
      let(:key) { node_two.key }
      let(:value) { node_two.value }

      it "returns the deleted key's value" do
        expect(remove_hash_entry.remove(key)).to eq(value)
      end

      context 'when a node precedes the key' do
        it "removes key's entry by assigning key's next_node to node's next_node" do
          expect(node_one).to receive(:next_node=).with(node_two.next_node)
          remove_hash_entry.remove(key)
        end
      end

      context 'when the key is the head of a linked list' do
        let(:hash_code) { 0 }
        let(:key) { node_zero.key }

        it "removes key's entry by assigning key's next_node as the head" do
          expect { remove_hash_entry.remove(key) }.to \
            change { buckets[hash_code] }
            .from(node_zero)
            .to(node_zero.next_node)
        end
      end
    end

    context 'if key does not exist' do
      let(:hash_code) { 1 }
      let(:key) { 'void' }

      it 'returns nil' do
        expect(remove_hash_entry.remove(key)).to eq(nil)
      end
    end
  end
end
