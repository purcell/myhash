class HashMap
  def initialize
    @storage = []
  end

  def size
    @storage.size
  end

  def has_key?(key)
    @storage.any? { |k, v| k == key }
  end

  def [](key)
    if found = @storage.find { |k, v| k == key }
      found[1]
    end
  end

  def []=(key, value)
    @storage.delete_if { |k, v| k == key }
    @storage.unshift [key, value]
  end
end
