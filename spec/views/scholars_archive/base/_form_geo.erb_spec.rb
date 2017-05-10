require 'spec_helper'
require 'rails_helper'
RSpec.describe 'scholars_archive/base/_form_geo.html.erb', type: :view do
  let(:work) do
    DefaultWork.new
  end

  let(:ability) { double }

  let(:form) do
    Hyrax::DefaultWorkForm.new(work, ability, controller)
  end

  before do
    assign(:form, form)
  end


  let(:page) do
    view.simple_form_for form do |f|
      render 'scholars_archive/base/form_geo', f: f
    end
  end

  context "for a new object" do
    let(:work) { DefaultWork.new }
    it "draws the page" do
      expect(page).to have_selector("form[action='/concern/default_works']")
      expect(page).to have_selector("select#new_geo_type option", count: 3)
    end

  end

  context "for a persisted object" do
    let(:test_point) {
      {
          label: 'point1',
          point: '[121.1, 121.2]'
      }
    }

    let(:test_box) {
      {
          label: 'box1',
          bbox: '[121.1, 121.2, 44.1, 44.2]'
      }
    }

    let!(:work) do
      DefaultWork.create do |work|
        work.title = ["Jill's Research"]
        work.nested_geo_attributes = [test_point, test_box]
      end
    end
    it "draws the page" do
      expect(page).to have_selector("select#new_geo_type option", count: 1)
      expect(page).to have_selector("div#geo_fields tr.nested_geo_points", count: 1)
      expect(page).to have_selector("div#geo_fields tr.nested_geo_bbox", count: 1)
    end

    it "renders nested geo points" do
      expect(page).to have_content("Geographic Points")
      expect(page).to have_selector("input[value='point1']")
      expect(page).to have_css('input.hidden[value="point1 ([121.1, 121.2])"]', visible: false)
    end

    it "renders nested geo boxes" do
      expect(page).to have_content("Bounding Boxes")
      expect(page).to have_selector("input[value='box1']")
      expect(page).to have_css('input.hidden[value="box1 ([121.1, 121.2, 44.1, 44.2])"]', visible: false)
    end
  end
end
