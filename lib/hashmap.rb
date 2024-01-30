# frozen_string_literal: true

require_relative '../lib/node'

# Data Structure: Hash Map
class HashMap
  def initialize(initial_size = 16)
    @buckets = Array.new(initial_size)
  end

  def set(key, value)
    hash_code = hash(key)

    if empty_bucket?(hash_code)
      set_linked_list(hash_code, key, value)
    else
      each(buckets(hash_code)) do |node|
        if key == node.key # overwrites old value
          node.value = value
          break
        end

        node.next_node = Node.new(key, value) if node.next_node.nil?
      end
    end
  end

  def get(key)
    hash_code = hash(key)

    each(buckets(hash_code)) do |node|
      return node.value if key == node.key
    end
  end

  def key?(key)
    hash_code = hash(key)

    each(buckets(hash_code)) do |node|
      return true if key == node.key
    end

    false
  end

  private

  def empty_bucket?(hash_code)
    @buckets[hash_code].nil?
  end

  def set_linked_list(hash_code, key, value)
    @buckets[hash_code] = Node.new(key, value)
  end

  def buckets(hash_code)
    @buckets[hash_code]
  end

  # This hash function only works with keys of type Spring
  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code % @buckets.length
  end

  def each(bucket)
    return to_enum(:each) unless block_given?

    return nil if bucket.nil?

    node = bucket

    loop do
      yield node

      break if node.next_node.nil?

      node = node.next_node
    end

    self
  end
end
