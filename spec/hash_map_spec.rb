require 'hash_map'

RSpec.describe HashMap do

  let(:map) { HashMap.new }

  context "when empty" do

    it "reports a zero size" do
      expect(map.size).to eql(0)
    end

    it "reports unknown keys" do
      expect(map.has_key?("hello")).to eql(false)
    end

    it "returns nil for arbitrary keys" do
      expect(map["blah"]).to eql(nil)
    end
  end

  context "when inserting values" do
    it "allows insertion of a key/value pair" do
      expect(map["key"]).to eql(nil)
      returned = (map["key"] = "value")
      expect(returned).to eql("value")
      expect(map.has_key?("key")).to eql(true)
      expect(map["key"]).to eql("value")
      expect(map.size).to eql(1)
    end

    it "allows insertion of multiple key/value pairs" do
      map["key1"] = "value1"
      map["key2"] = "value2"
      expect(map.has_key?("key1")).to eql(true)
      expect(map["key1"]).to eql("value1")
      expect(map.has_key?("key2")).to eql(true)
      expect(map["key2"]).to eql("value2")
      expect(map.size).to eql(2)
    end
  end

  context "when setting keys which already exist" do
    it "replaces the old keys" do
      map["key"] = "one"
      map["key"] = "two"
      expect(map["key"]).to eql("two")
      expect(map.size).to eql(1)
    end
  end

  it "can enumerate its pairs" do
    map["key1"] = "one"
    map["key2"] = "two"
    expect(map.items.to_a.sort).to eql([["key1", "one"], ["key2", "two"]])
  end

  it "allows nil keys" do
    map[nil] = "hello"
    expect(map[nil]).to eql("hello")
  end

  def key_hashing_to(key, hashcode)
    allow(key).to receive(:myhash).and_return(hashcode)
    key
  end

  it "handles hash collisions" do
    key1 = key_hashing_to("key1", 1)
    key2 = key_hashing_to("key2", 1)
    map[key1] = "one"
    map[key2] = "two"
    expect(map.size).to eql(2)
    expect(map[key1]).to eql("one")
    expect(map[key2]).to eql("two")
  end

  describe "bucket allocation" do
    it "starts off with multiple empty buckets" do
      expect(map.bucket_sizes.length).to be >= 2
      expect(map.bucket_sizes.all? { |size| size == 0 }).to eql(true)
    end

    it "chooses between buckets based on hash code modulus bucket count" do
      key1 = key_hashing_to("key1", 0)
      key2 = key_hashing_to("key2", 1)
      key3 = key_hashing_to("key3", 1)
      map[key1] = "one"
      expect(map.bucket_sizes.first(2)).to eql([1, 0])
      map[key2] = "two"
      expect(map.bucket_sizes.first(2)).to eql([1, 1])
      map[key3] = "three"
      expect(map.bucket_sizes.first(2)).to eql([1, 2])
    end
  end

  describe "bucket reallocation" do
    it "reports its load factor" do
      expect(map.load_factor).to eql(0.0)
      map["key1"] = "one"
      expect(map.load_factor).to eql(1.0 / map.bucket_sizes.size)
      map["key2"] = "two"
      expect(map.load_factor).to eql(2.0 / map.bucket_sizes.size)
    end

    it "increases buckets when there are more items than buckets" do
      initial_buckets = map.bucket_sizes.size
      (1..initial_buckets).map do |i|
        map["key#{i}"] = "value#{i}"
      end
      expect(map.bucket_sizes.size).to eql(initial_buckets * 2)
      expect(map.size).to eql(initial_buckets)
    end
  end
end
