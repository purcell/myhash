class Bucket

  def initialize
    @entries = []
  end

  def size
    @entries.size
  end

  def []=(key, val)
    @entries.delete_if(&matches_key(key))
    @entries.unshift([key, val].freeze)
  end

  def [](key)
    if found = @entries.find(&matches_key(key))
      found[1]
    end
  end

  def items
    @entries.each
  end

  def has_key?(key)
    @entries.any?(&matches_key(key))
  end

  private

  def matches_key(key)
    ->(k, v) { k == key }
  end
end
