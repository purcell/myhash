require 'hash_map'

RSpec.describe HashMap do


  context "when empty" do
    let(:map) { HashMap.new }

    it "reports a zero size" do
      expect(map.size).to eql(0)
    end

    it "reports unknown keys" do
      expect(map.has_key?("hello")).to eql(false)
    end

    it "returns nil for arbitrary keys" do
      expect(map["blah"]).to eql(nil)
    end

    it "allows insertion of a key/value pair" do
      expect(map["key"]).to eql(nil)
      returned = (map["key"] = "value")
      expect(returned).to eql("value")
      expect(map.has_key?("key")).to eql(true)
      expect(map["key"]).to eql("value")
    end

    it "allows insertion of multiple key/value pairs" do
      map["key1"] = "value1"
      map["key2"] = "value2"
      expect(map.has_key?("key1")).to eql(true)
      expect(map["key1"]).to eql("value1")
      expect(map.has_key?("key2")).to eql(true)
      expect(map["key2"]).to eql("value2")
    end
  end

end
