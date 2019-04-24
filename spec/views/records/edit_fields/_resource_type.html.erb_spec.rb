# frozen_string_literal: true

RSpec.describe 'records/edit_fields/_resource_type.html.erb', type: :view do
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "records/edit_fields/resource_type", f: f, key: 'based_near' %>
      <% end %>
    )
  end

  before do
    assign(:form, form)
    render inline: form_template
  end

  context 'when rendering a GTD' do
    let(:work) { GraduateThesisOrDissertation.new }
    let(:form) { Hyrax::GraduateThesisOrDissertationForm.new(work, nil, controller) }

    it { expect(rendered).to have_selector('option[value="Dissertation"]') }
    it { expect(rendered).to have_selector('option[value="Masters Thesis"]') }
  end

  context 'when rendering a HCT' do
    let(:work) { HonorsCollegeThesis.new }
    let(:form) { Hyrax::HonorsCollegeThesisForm.new(work, nil, controller) }

    it { expect(rendered).to have_selector('option[value="Honors College Thesis"]') }
  end
end
