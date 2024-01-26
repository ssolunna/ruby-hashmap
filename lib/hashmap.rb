# frozen_string_literal: true

require_relative '../lib/node'

class HashMap
  def initialize(initial_size = 16)
    @buckets = Array.new(initial_size)
  end

  def set(key, value)
    hash_code = hash(key)

    if @buckets[hash_code].nil?
      @buckets[hash_code] = Node.new(key, value) # add_node
    else
      each(@buckets[hash_code]) do |node|
        node.value = value if key == node.key
      end
    end
  end

  private

  def hash(key) # key must be of type String
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code % @buckets.length
  end

  def each(bucket)
    return to_enum(:each) unless block_given?

    node = bucket 

    loop do
      yield node 

      break if node.next_node.nil?

      node = node.next_node
    end
    
    self
  end
end
