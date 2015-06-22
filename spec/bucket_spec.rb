require 'bucket'

RSpec.describe Bucket do

  context "when creating a bucket" do
    it "starts off empty" do
      bucket = Bucket.new
      expect(bucket.size).to eql(0)
    end
  end

  context "when adding pairs" do
    it "changes the size" do
      bucket = Bucket.new
      bucket["foo"] = "bar"
      expect(bucket.size).to eql(1)
    end

    it "remembers the key" do
      bucket = Bucket.new
      bucket["foo"] = "bar"
      expect(bucket.has_key?("foo")).to eql(true)
    end

    it "remembers the value" do
      bucket = Bucket.new
      bucket["foo"] = "bar"
      expect(bucket["foo"]).to eql("bar")
    end

    it "can overwrite pairs" do
      bucket = Bucket.new
      bucket["foo"] = "one"
      bucket["foo"] = "two"
      expect(bucket["foo"]).to eql("two")
      expect(bucket.size).to eql(1)
    end
  end

  it "can enumerate its items" do
    bucket = Bucket.new
    bucket["key1"] = "one"
    bucket["key2"] = "two"
    expect(bucket.items.to_a.sort).to eql([["key1", "one"], ["key2", "two"]])
  end
end
