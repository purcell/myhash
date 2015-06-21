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
      map["key"] = "value"
      expect(map.has_key?("key")).to eql(true)
      expect(map["key"]).to eql("value")
    end
  end

end
