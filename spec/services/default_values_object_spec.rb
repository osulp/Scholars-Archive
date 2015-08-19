require 'rails_helper'

RSpec.describe DefaultValuesObject do
  let(:publisher) { 'Oregon State University' }
  let(:language_uri) { 'http://id.loc.gov/vocabulary/iso639-1/en' }

  let(:generic_file) do
    GenericFile.new(title: ['some title']).tap do |f|
      f.apply_depositor_metadata("bob")
    end
  end
  let(:form) { Sufia::Forms::BatchEditForm.new(generic_file) }

  describe "#set_default_values" do
    it "should return default publisher" do
      defaults = DefaultValuesObject.new(form).set_default_values
      expect(defaults.publisher).to eq publisher
    end
    it "should return default language" do
      defaults = DefaultValuesObject.new(form).set_default_values
      expect(defaults.language).to eq language_uri
    end

    context "when defaults multiple values" do
      before do
        DefaultValuesObject.any_instance.stub(:default_values).and_return({'publisher' => ['banana', 'bla']})
      end
      it "defaults multiple values" do
        defaults = DefaultValuesObject.new(form).set_default_values
        expect(defaults.publisher[0]).to eq 'banana'
        expect(defaults.publisher[1]).to eq 'bla'
      end
    end
  end
end
