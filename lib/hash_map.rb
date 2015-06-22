class HashMap
  def initialize
    @buckets = [Bucket.new]
  end

  def size
    @buckets.inject(0) { |total, bucket| total + bucket.size }
  end

  def has_key?(key)
    find_bucket(key).has_key?(key)
  end

  def [](key)
    find_bucket(key)[key]
  end

  def []=(key, value)
    find_bucket(key)[key] = value
  end

  private

  def find_bucket(key)
    @buckets[key.myhash % @buckets.size]
  end
end

class String
  def myhash
    hash = 0xf00
    chars.each do |c|
      hash ^= c.ord
    end
    hash
  end
end

class NilClass
  def myhash
    0
  end
end
