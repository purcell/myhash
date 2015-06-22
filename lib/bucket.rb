class Bucket

  def initialize
    @entries = []
  end

  def size
    @entries.size
  end

  def []=(key, val)
    @entries.delete_if { |k, v| key == k }
    @entries.unshift([key, val].freeze)
  end

  def [](key)
    if found = @entries.find { |k, v| k == key }
      found[1]
    end
  end

  def items
    @entries.each
  end

  def has_key?(key)
    @entries.any? { |k,v| k == key }
  end
end
