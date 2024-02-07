# frozen_string_literal: true

require_relative '../lib/node'

# Data Structure: Hash Map
class HashMap
  def initialize(initial_size = 16)
    @initial_size = initial_size
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

  def remove(key)
    hash_code = hash(key)

    previous_node = nil

    each(buckets(hash_code)) do |node|
      if key == node.key
        if previous_node.nil?
          @buckets[hash_code] = node.next_node
        else
          previous_node.next_node = node.next_node
        end

        return node.value
      end

      previous_node = node
    end

    nil
  end

  def length
    size = 0

    each { |_node| size += 1 }

    size
  end

  def clear!
    @buckets = Array.new(@initial_size)
  end

  def keys
    array_of_keys = []

    each do |node|
      array_of_keys << node.key
    end

    array_of_keys
  end

  def values
    array_of_values = []

    each do |node|
      array_of_values << node.value
    end

    array_of_values
  end

  def entries
    array_of_entries = []

    each do |node|
      array_of_entries << [node.key, node.value]
    end

    array_of_entries
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

  def each(bucket = @buckets)
    return to_enum(:each) unless block_given?

    bucket = [*bucket]

    return nil if bucket.compact.empty?

    bucket.each do |node|
      loop do
        break if node.nil?

        yield node

        node = node.next_node
      end
    end

    self
  end
end
