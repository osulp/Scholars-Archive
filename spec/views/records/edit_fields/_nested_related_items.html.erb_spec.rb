# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
RSpec.describe 'records/edit_fields/_nested_related_items.html.erb', type: :view do
  let(:ability) { double(current_user: current_user) }
  let(:current_user) { User.new(email: 'test@example.com',guest: false) }

  let(:work) {
    Default.new do |work|
      work.attributes = attributes
    end
  }
  let(:form) do
    Hyrax::DefaultForm.new(work, ability, controller)
  end
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "records/edit_fields/nested_related_items", f: f, key: 'nested_related_items' %>
      <% end %>
    )
  end

  before do
    allow(view).to receive(:signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:can?).and_return(true)
  end

  context 'for a persisted object nested related items' do
    let(:test_label) { 'Oregon Digital' }
    let(:test_url) { 'https://oregondigital.org/catalog/' }
    let(:test_item) do
      {
          label: test_label,
          related_url: test_url
      }
    end

    let(:attributes) {
      {
          title: ['test'],
          creator: ['Blah'],
          rights_statement: ['blah.blah'],
          resource_type: ['blah'],
          nested_related_items_attributes: [test_item]
      }
    }

    before do
      assign(:curation_concern, work)
      # form.nested_geo.each { |geo| geo.point.present? ? geo.type = :point.to_s : '' }
      # form.nested_geo.each { |geo| geo.point.present? ? geo.point = "#{test_point[:label]} (#{test_point[:point]})" : '' }
      assign(:form, form)
      render inline: form_template
    end

    it 'draws the page' do
      expect(rendered).to have_content('Related Items')
    end

    it 'drows the input label' do
      expect(rendered).to have_selector('input[value="'+test_label+'"]', visible: true)
    end

    it 'draws the input url' do
      expect(rendered).to have_selector('input[value="'+test_url+'"]', visible: true)
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
      expect(rendered).to have_selector('input.nested-field.multi-text-field', visible: true)
    end
  end
end
