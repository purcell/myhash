class HashMap
  def initialize
    @storage = []
  end

  def size
    0
  end

  def has_key?(key)
    @storage.any? { |k, v| k == key }
  end

  def [](key)
    if entry = @storage.find { |k, v| k == key }
      entry[1]
    end
  end

  def []=(key, value)
    @storage << [key, value]
  end
end
