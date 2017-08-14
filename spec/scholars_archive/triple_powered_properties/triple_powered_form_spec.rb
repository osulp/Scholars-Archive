require 'rails_helper'

RSpec.describe ScholarsArchive::TriplePoweredProperties::TriplePoweredForm do
  describe "#has_triple_powered_property?" do
    let(:form) { Hyrax::DefaultForm.new(Default.new({ based_near: [ url ], title: ['TestTest'] }), instance_double("Ability"), instance_double("Controller")) }
    let(:url) { 'http://opaquenamespace.org/ns/TestVocabulary/TestTerm' }
    xit "should return a truthy statement if it has a triple powered property" do
      expect(form.has_triple_powered_property?({field: :based_near})).to eq true
    end
    it "should return a falsey statement if it does not have a triple powered property" do
      expect(form.has_triple_powered_property?({field: :anything_else})).to eq false
    end
  end
end
