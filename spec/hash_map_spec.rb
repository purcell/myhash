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

  it "handles hash collisions" do
    key1 = "key1"
    class << key1
      def myhash
        1
      end
    end
    key2 = "key2"
    class << key2
      def myhash
        1
      end
    end
    map[key1] = "one"
    map[key2] = "two"
    expect(map.size).to eql(2)
    expect(map[key1]).to eql("one")
    expect(map[key2]).to eql("two")
  end

  it "allows nil keys" do
    map[nil] = "hello"
    expect(map[nil]).to eql("hello")
  end
end
