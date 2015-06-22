require 'bucket'

class HashMap
  attr_reader :size

  def initialize
    @buckets = create_buckets(4)
    @size = 0
  end

  def has_key?(key)
    find_bucket(key).has_key?(key)
  end

  def [](key)
    find_bucket(key)[key]
  end

  def []=(key, value)
    insert!(key, value)
    maybe_rebalance
  end

  def items
    saved_buckets = @buckets.dup
    Enumerator.new do |enum|
      saved_buckets.each do |bucket|
        bucket.items.each do |item|
          enum << item
        end
      end
    end
  end

  def bucket_sizes
    @buckets.map(&:size)
  end

  def load_factor
    size.to_f / @buckets.size
  end

  private

  def insert!(key, value)
    bucket = find_bucket(key)
    initial_size = bucket.size
    bucket[key] = value
    @size += bucket.size - initial_size
  end

  def create_buckets(n)
    n.times.map { Bucket.new }
  end

  def maybe_rebalance
    if load_factor > 0.75
      enum = items
      @buckets = create_buckets(@buckets.size * 2)
      @size = 0
      enum.each do |key, val|
        insert!(key, val)
      end
    end
  end

  def find_bucket(key)
    @buckets[key.myhash % @buckets.size]
  end
end

class String
  def myhash
    hash = 0x0000
    each_byte.with_index do |byte, i|
      hash ^= byte << i % 32
    end
    hash
  end
end

class NilClass
  def myhash
    0
  end
end
