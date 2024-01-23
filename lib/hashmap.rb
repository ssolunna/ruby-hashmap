# frozen_string_literal: true

class HashMap
  def initialize(initial_size = 16)
    @buckets = Array.new(initial_size)
  end

  def hash(key) # key must be of type String
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code % @buckets.length
  end
end
