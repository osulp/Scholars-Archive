# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
RSpec.describe 'records/edit_fields/_degree_field.html.erb', type: :view do
  let(:ability) { double(current_user: current_user) }
  let(:current_user) { User.new(email: 'test@example.com',guest: false) }

  let(:work) {
    GraduateThesisOrDissertation.new do |work|
      work.attributes = attributes
    end
  }
  let(:form) do
    Hyrax::GraduateThesisOrDissertationForm.new(work, ability, controller)
  end
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "records/edit_fields/degree_field", f: f, key: 'degree_field' %>
      <% end %>
    )
  end

  let(:test_sorted_all_options) do
    [
        ['Adult Education - {1989..1990,1995,2001,2016}', 'http://opaquenamespace.org/ns/osuDegreeFields/OGvwFaYi'],
        ['Animal Breeding - 1952', 'http://opaquenamespace.org/ns/osuDegreeFields/KWzvXUyz']
    ]
  end

  let(:test_sorted_all_options_truncated_values) do
    [
        'Adult Education',
        'Animal Breeding'
    ]
  end

  let(:test_sorted_current_options) do
    [
        ['Adult Education - {1989..1990,1995,2001,2016}', 'http://opaquenamespace.org/ns/osuDegreeFields/OGvwFaYi']
    ]
  end

  let(:test_sorted_current_options_truncated_values) do
    [
        'Adult Education'
    ]
  end

  before do
    allow(view).to receive(:signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:can?).and_return(true)
    allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return(test_sorted_all_options)
    allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options).and_return(test_sorted_current_options)
  end

  context 'when user is admin' do
    let(:attributes) { { title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: ['blah'] } }

    before do
      allow(current_user).to receive(:admin?).and_return(true)
      assign(:form, form)
      render inline: form_template
    end

    it 'has the a select box with all available options' do
      expect(rendered).to have_select('graduate_thesis_or_dissertation_degree_field', with_options: test_sorted_all_options_truncated_values)
    end
  end

  context 'when user is not an admin' do
    let(:attributes) { { title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: ['blah'] } }

    before do
      allow(current_user).to receive(:admin?).and_return(false)
      assign(:form, form)
      render inline: form_template
    end

    it 'has the a select box with all available options' do
      expect(rendered).to have_select('graduate_thesis_or_dissertation_degree_field', with_options: test_sorted_current_options_truncated_values)
    end
  end

  context "for a work with degree field where 'Other' was selected and there is an OtherOption record in the database" do
    let(:attributes) { { title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: ['blah'], degree_field: ['Other'] } }
    let(:degree_field_other_option_test) { 'testing degree field other option' }

    before do
      allow(current_user).to receive(:admin?).and_return(true)
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return([['Other', 'Other']])
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options).and_return([['Other', 'Other']])
      work.degree_field_other = degree_field_other_option_test
      assign(:degree_field_other_options, [OtherOption.find_or_create_by(name: degree_field_other_option_test, work_id: work.id)])
      assign(:form, form)
      render inline: form_template
    end

    it 'has the "other" input not visible in the form' do
      expect(rendered).to have_selector('.degree_field_other input[type="hidden"]', visible: false)
    end

    it 'has the "other" value listed in the table' do
      expect(rendered).to have_content(degree_field_other_option_test)
    end
  end

  context "for a work with degree field where 'Other' was not selected" do
    let(:attributes) { { title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: ['blah'], degree_field:
        ['Animal Breeding - 1952', 'http://opaquenamespace.org/ns/osuDegreeFields/KWzvXUyz']
    } }

    before do
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return([['Other', 'Other']])
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options).and_return([['Other', 'Other']])
      assign(:form, form)
      render inline: form_template
    end

    it 'has the "other" input hidden in the form' do
      expect(rendered).to have_selector('.degree_field_other input[type="hidden"]', visible: false)
      expect(rendered).to have_selector('.degree_field_other input.hidden', visible: false)
    end
  end
end
