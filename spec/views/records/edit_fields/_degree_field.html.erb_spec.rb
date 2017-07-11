require 'spec_helper'
require 'rails_helper'
RSpec.describe 'records/edit_fields/_degree_field.html.erb', type: :view do
  let(:ability) { double }
  let(:work) {
    GraduateThesisOrDissertation.new do |work|
      work.attributes = attributes
      work.save!
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

  context "for a work with degree field where 'Other' was selected and there is an OtherOption record in the database" do
    let(:attributes) { { title: ["test"], creator: ["Blah"], rights_statement: ["blah.blah"], resource_type: ["blah"], degree_field: "Other" } }
    let(:degree_field_other_option_test) {"testing degree field other option"}

    before do
      OtherOption.find_or_create_by(name: degree_field_other_option_test, work_id: work.id)
      work.degree_field_other = degree_field_other_option_test
      assign(:form, form)
      render inline: form_template
    end

    it 'has the "other" input visible in the form' do
      expect(rendered).to have_selector('.degree-field-other input[type="text"]')
    end

    it 'has the "other" input value as the default in the form' do
      expect(rendered).to have_selector('.degree-field-other input[value="'+degree_field_other_option_test+'"]')
    end
  end

  context "for a work with degree field where 'Other' was not selected" do
    let(:attributes) { { title: ["test"], creator: ["Blah"], rights_statement: ["blah.blah"], resource_type: ["blah"], degree_field: "test" } }

    before do
      assign(:form, form)
      render inline: form_template
    end

    it 'has the "other" input hidden in the form' do
      expect(rendered).to have_selector('.degree-field-other input[type="hidden"]', visible: false)
      expect(rendered).to have_selector('.degree-field-other input.hidden', visible: false)
    end
  end
end