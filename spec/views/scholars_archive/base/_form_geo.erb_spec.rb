require 'spec_helper'
require 'rails_helper'
RSpec.describe 'scholars_archive/base/_form_geo.html.erb', type: :view do
  let(:ability) { double }

  context "for a persisted object nested geo points" do
    let(:test_point) do
      {
          label: 'point1',
          point: '[121.1, 121.2]'
      }
    end
    let(:work1) do
      Default.new do |work|
        work.attributes = {title: ["test"], creator: ["Blah"], rights_statement: ["blah.blah"], resource_type: ["blah"], nested_geo_attributes: [test_point]}
        work.save!
      end
    end

    let(:form1) do
      Hyrax::DefaultForm.new(work1, ability, controller)
    end

    it "draws the page" do
      form1.nested_geo.each { |geo| geo.point.present? ? geo.type = :point.to_s : '' }
      assign(:form, form1)
      view.simple_form_for [main_app, form1] do |f|
        render 'scholars_archive/base/form_geo', f: f
      end
      expect(rendered).to have_selector("select#new_geo_type option", count: 2)
    end

    it "drows the point label" do
      assign(:form, form1)
      view.simple_form_for form1 do |f|
        render 'scholars_archive/base/nested_geo_points', f: f, coordinates_group: f.object.model.nested_geo.select { |t| t.present? }
      end
      expect(rendered).to have_selector('input[value="point1"]', visible: true)
    end

    it "draws the point value" do
      assign(:form, form1)
      view.simple_form_for form1 do |f|
        render 'scholars_archive/base/nested_geo_points', f: f, coordinates_group: f.object.model.nested_geo.select { |t| t.present? }
      end
      expect(rendered).to have_selector('input.hidden[value="point1 ([121.1, 121.2])"]', visible: false)
    end

  end

  context "for a persisted object nested geo bbox" do
    let(:test_box) do
      {
          label: 'box1',
          bbox: '[121.1, 121.2, 44.1, 44.2]'
      }
    end

    let(:work2) do
      Default.new do |work|
        work.attributes = {title: ["test"], nested_geo_attributes: [test_box]}
        work.save!
      end
    end

    let(:form2) do
      Hyrax::DefaultForm.new(work2, ability, controller)
    end

    it "draws the page" do
      form2.nested_geo.each { |geo| geo.point.present? ? geo.type = :point.to_s : '' }
      assign(:form, form2)
      view.simple_form_for [main_app, form2] do |f|
        render 'scholars_archive/base/form_geo', f: f
      end
      expect(rendered).to have_selector("select#new_geo_type option", count: 2)
    end

    it "drows the bbox label" do
      assign(:form, form2)
      view.simple_form_for form2 do |f|
        render 'scholars_archive/base/nested_geo_bbox', f: f, coordinates_group: f.object.model.nested_geo.select { |t| t.present? }
      end
      expect(rendered).to have_selector('input[value="box1"]', visible: true)
    end

    it "draws the bbox value" do
      assign(:form, form2)
      view.simple_form_for form2 do |f|
        render 'scholars_archive/base/nested_geo_bbox', f: f, coordinates_group: f.object.model.nested_geo.select { |t| t.present? }
      end
      expect(rendered).to have_selector('input.hidden[value="box1 ([121.1, 121.2, 44.1, 44.2])"]', visible: false)
    end


  end

  context "for a new object" do
    let(:work) { Default.new }

    let(:form) do
      Hyrax::DefaultForm.new(work, ability, controller)
    end

    it "draws the page" do
      assign(:form, form)
      view.simple_form_for [main_app, form] do |f|
        render 'scholars_archive/base/form_geo', f: f
      end
      expect(rendered).to have_selector("select#new_geo_type option", count: 3)
    end
  end
end
