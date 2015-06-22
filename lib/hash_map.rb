require 'bucket'

class HashMap
  def initialize
    @buckets = create_buckets(4)
  end

  def size
    bucket_sizes.inject(0, :+)
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
    find_bucket(key)[key] = value
  end

  def create_buckets(n)
    n.times.map { Bucket.new }
  end

  def maybe_rebalance
    if load_factor > 0.75
      enum = items
      @buckets = create_buckets(@buckets.size * 2)
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
    hash = 0xf00
    each_byte do |byte|
      hash ^= byte
    end
    hash
  end
end

class NilClass
  def myhash
    0
  end
end
