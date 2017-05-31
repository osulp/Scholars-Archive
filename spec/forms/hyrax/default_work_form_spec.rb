# Generated via
#  `rails generate hyrax:work DefaultWork`
require 'rails_helper'

RSpec.describe Hyrax::DefaultWorkForm do
  let(:work) { DefaultWork.new }
  let(:form) { described_class.new(work, nil, nil) }

  describe ".build_permitted_params" do
    it "should permit nested author attributes" do
      expect(described_class.build_permitted_params).to include(
          {
              :nested_geo_attributes => [
                :id,
                :_destroy,
                :label,
                :point,
                :bbox
              ],
          }
      )
    end
  end

  describe "field instantiation" do
    it "should build a nested field" do
      form
      expect(form.model.nested_geo.length).to eq 0
    end
  end
end