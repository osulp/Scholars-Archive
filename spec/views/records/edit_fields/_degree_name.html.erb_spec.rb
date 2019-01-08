# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
RSpec.describe 'records/edit_fields/_degree_name.html.erb', type: :view do
  let(:ability) { instance_double(current_user: current_user) }
  let(:current_user) { User.new(email: 'test@example.com', guest: false) }
  let(:work) do
    GraduateThesisOrDissertation.new do |work|
      work.attributes = attributes
    end
  end
  let(:form) do
    Hyrax::GraduateThesisOrDissertationForm.new(work, ability, controller)
  end
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render 'records/edit_fields/degree_name', f: f, key: 'degree_name' %>
      <% end %>
    )
  end

  before do
    allow(view).to receive(:signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:can?).and_return(true)
  end

  context 'when for a work with degree name where Other was selected and there is an OtherOption record for that work' do
    let(:attributes) { { title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: ['blah'], degree_name: ['Other'] } }
    let(:degree_name_other_option_test) { 'testing degree name other option' }

    before do
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return([%w[Other Other]])
      work.degree_name_other = degree_name_other_option_test
      assign(:degree_name_other_options, [OtherOption.find_or_create_by(name: degree_name_other_option_test, work_id: work.id)])
      assign(:form, form)
      render inline: form_template
    end

    it 'has the other input not visible in the form' do
      expect(rendered).to have_selector('.degree_name_other input[type=\'hidden\']', visible: false)
    end

    it 'has the other value listed in the table' do
      expect(rendered).to have_content(degree_name_other_option_test)
    end
  end

  context 'when for a work with degree name where othero was not selected' do
    let(:attributes) { { title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: ['blah'], degree_name: ['test'] } }

    before do
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return([%w[Other Other]])
      assign(:form, form)
      render inline: form_template
    end

    it 'has the other input hidden in the form' do
      expect(rendered).to have_selector('.degree_name_other input[type=\'hidden\']', visible: false)
      expect(rendered).to have_selector('.degree_name_other input.hidden', visible: false)
    end
  end
end
