require 'rails_helper'

RSpec.describe AttributeURIConverter do
  describe "#convert_attributes" do
    it "converts all URI-like values in a hash to RDF" do
      attrs = {
        # Simplest case
        :a => "scheme://host",

        # Broken "URI"
        :b => "http:example.com",

        # String
        :c => "definitely not a uri",

        # Array with a URI and a non-URI
        :d => ["http://example.org", "also not a uri"],

        # Single-item array
        :e => ["bar"],
      }
      converted = AttributeURIConverter.new(attrs).convert_attributes
      expect(converted[:a]).to eql(RDF::URI("scheme://host"))
      expect(converted[:b]).to eql("http:example.com")
      expect(converted[:c]).to eql("definitely not a uri")
      expect(converted[:d]).to eql([RDF::URI("http://example.org"), "also not a uri"])
      expect(converted[:e]).to eql(["bar"])
      expect(converted.keys).to eql([:a, :b, :c, :d, :e])
    end
  end
end
