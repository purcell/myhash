class HashMap
  def size
    0
  end

  def has_key?(key)
    @key == key
  end

  def [](key)
    @value
  end

  def []=(key, value)
    @key = key
    @value = value
  end
end
