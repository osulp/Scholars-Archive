# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
RSpec.describe 'records/edit_fields/_geo_section.html.erb', type: :view do
  let(:ability) { double(current_user: current_user) }
  let(:current_user) { User.new(email: 'test@example.com', guest: false) }

  let(:work) do
    Default.new do |work|
      work.attributes = attributes
    end
  end
  let(:form) do
    Hyrax::DefaultForm.new(work, ability, controller)
  end
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "records/edit_fields/geo_section", f: f, key: 'geo_section' %>
      <% end %>
    )
  end

  before do
    allow(view).to receive(:signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:can?).and_return(true)
  end

  context 'for a persisted object nested geo points' do
    let(:test_point) do
      {
        label: 'point1',
        point: '[121.1, 121.2]'
      }
    end

    let(:attributes) do
      {
        title: ['test'],
        creator: ['Blah'],
        rights_statement: ['blah.blah'],
        resource_type: ['blah'],
        nested_geo_attributes: [test_point]
      }
    end

    before do
      assign(:curation_concern, work)
      form.nested_geo.each do |geo|
        geo.point.present? ? geo.type = :point.to_s : ''
        geo.point.present? ? geo.point = "#{test_point[:label]} (#{test_point[:point]})" : ''
      end
      assign(:form, form)
      render inline: form_template
    end

    it 'draws the page' do
      expect(rendered).to have_selector('select#new_geo_type option', count: 2)
    end

    it 'drows the point label' do
      expect(rendered).to have_selector('input[value="point1"]', visible: true)
    end

    it 'draws the point value' do
      expect(rendered).to have_selector('input.hidden[value="point1 ([121.1, 121.2])"]', visible: false)
    end
  end

  context 'for a persisted object nested geo bbox' do
    let(:test_box) do
      {
        label: 'box1',
        bbox: '[121.1, 121.2, 44.1, 44.2]'
      }
    end

    let(:attributes) do
      {
        title: ['test'],
        nested_geo_attributes: [test_box]
      }
    end

    before do
      assign(:curation_concern, work)
      form.nested_geo.each do |geo|
        geo.bbox.present? ? geo.type = :bbox.to_s : ''
        geo.bbox.present? ? geo.bbox = "#{test_box[:label]} (#{test_box[:bbox]})" : ''
      end
      assign(:form, form)
      render inline: form_template
    end

    it 'draws the page' do
      expect(rendered).to have_selector('select#new_geo_type option', count: 2)
    end

    it 'drows the bbox label' do
      expect(rendered).to have_selector('input[value="box1"]', visible: true)
    end

    it 'draws the bbox value' do
      expect(rendered).to have_selector('input.hidden[value="box1 ([121.1, 121.2, 44.1, 44.2])"]', visible: false)
    end
  end

  context 'for a new object' do
    let(:work) { Default.new }

    before do
      assign(:curation_concern, work)
      assign(:form, form)
      render inline: form_template
    end

    it 'draws the page' do
      expect(rendered).to have_selector('select#new_geo_type option', count: 3)
    end
  end
end
