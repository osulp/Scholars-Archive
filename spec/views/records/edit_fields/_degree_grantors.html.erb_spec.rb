# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
RSpec.describe 'records/edit_fields/_degree_grantors.html.erb', type: :view do
  let(:ability) { double(current_user: current_user) }
  let(:current_user) { User.new(email: 'test@example.com', guest: false) }

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
        <%= render "records/edit_fields/degree_grantors", f: f, key: 'degree_grantors' %>
      <% end %>
    )
  end

  before do
    allow(view).to receive(:signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:can?).and_return(true)
  end

  context "for a work with degree grantors where 'Other' was selected and there is an OtherOption record for that work" do
    let(:attributes) { { title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: ['blah'], degree_grantors: 'Other' } }
    let(:degree_grantors_other_option_test) { 'testing degree grantors other option' }

    before do
      OtherOption.find_or_create_by(name: degree_grantors_other_option_test, work_id: work.id)
      work.degree_grantors_other = degree_grantors_other_option_test
      assign(:form, form)
      render inline: form_template
    end

    it 'has the "other" input visible in the form' do
      expect(rendered).to have_selector('.degree-grantors-other input[type="text"]')
    end

    it 'has the "other" input value as the default in the form' do
      expect(rendered).to have_selector('.degree-grantors-other input[value="'+degree_grantors_other_option_test+'"]')
    end
  end

  context "for a work with degree grantors where 'Other' was not selected" do
    let(:attributes) { { title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: ['blah'], degree_grantors: 'test' } }

    before do
      assign(:form, form)
      render inline: form_template
    end

    it 'has the "other" input hidden in the form' do
      expect(rendered).to have_selector('.degree-grantors-other input[type="hidden"]', visible: false)
      expect(rendered).to have_selector('.degree-grantors-other input.hidden', visible: false)
    end
  end
end
