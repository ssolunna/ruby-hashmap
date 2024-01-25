# frozen_string_literal: true

require_relative '../lib/node'

class HashMap
  def initialize(initial_size = 16)
    @buckets = Array.new(initial_size)
  end

  def set(key, value)
    hash_code = hash(key)

    @buckets[hash_code] = Node.new(key, value)
  end

  private

  def hash(key) # key must be of type String
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code % @buckets.length
  end
end
