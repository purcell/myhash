class HashMap
  def initialize
    @buckets = [Bucket.new]
  end

  def size
    @buckets.inject(0) { |total, bucket| total + bucket.size }
  end

  def has_key?(key)
    @buckets.any? { |bucket| bucket.has_key?(key) }
  end

  def [](key)
    @buckets.each do |bucket|
      if found = bucket[key]
        return found
      end
    end
    nil
  end

  def []=(key, value)
    @buckets.first[key] = value
  end
end
  end
end
