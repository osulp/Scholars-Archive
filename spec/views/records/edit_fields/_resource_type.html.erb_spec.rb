# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
RSpec.describe 'records/edit_fields/_resource_type.html.erb', type: :view do
  let(:ability) { double(current_user: current_user) }
  let(:current_user) { User.new(email: 'test@example.com', guest: false) }
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "records/edit_fields/resource_type", f: f, key: 'resource_type' %>
      <% end %>
    )
  end

  context 'when the work is a graduate thesis' do
    let(:attributes) { { title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: [''], degree_name: ['test'] } }
    let(:work) do
      GraduateThesisOrDissertation.new do |work|
        work.attributes = attributes
      end
    end
    let(:f) do
      Hyrax::GraduateThesisOrDissertationForm.new(work, ability, controller)
    end

    before do
      allow(view).to receive(:signed_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(current_user)
      allow(view).to receive(:can?).and_return(true)
      allow(Hyrax::ResourceTypesService).to receive(:select_options).and_return([['Honors College Thesis'], ['Dissertation'], ['Masters Thesis']])
      assign(:form, f)
    end

    it 'displays the proper select options' do
      render inline: form_template

      expect(rendered).to have_content('Dissertation')
      expect(rendered).not_to have_content('Honors College Thesis')
    end
  end

  context 'when the work is a Honors College Thesis' do
    let(:attributes) { { title: ['test'], creator: ['Blah'], rights_statement: ['blah.blah'], resource_type: [''], degree_name: ['test'] } }
    let(:work) do
      HonorsCollegeThesis.new do |work|
        work.attributes = attributes
      end
    end
    let(:f) do
      Hyrax::HonorsCollegeThesisForm.new(work, ability, controller)
    end

    before do
      allow(view).to receive(:signed_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(current_user)
      allow(view).to receive(:can?).and_return(true)
      allow(Hyrax::ResourceTypesService).to receive(:select_options).and_return([['Honors College Thesis'], ['Dissertation'], ['Masters Thesis']])
      assign(:form, f)
    end

    it 'displays the proper select options' do
      render inline: form_template

      expect(rendered).to have_content('Honors College Thesis')
      expect(rendered).not_to have_content('Dissertation')
    end
  end
end
