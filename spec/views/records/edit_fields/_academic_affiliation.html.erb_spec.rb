require 'spec_helper'
require 'rails_helper'
RSpec.describe 'records/edit_fields/_academic_affiliation.html.erb', type: :view do
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
        <%= render "records/edit_fields/academic_affiliation", f: f, key: 'academic_affiliation' %>
      <% end %>
    )
  end
  let(:test_sorted_all_options) do
    [
        ["Accounting - 1979/1992, 2009/open", "http://opaquenamespace.org/ns/osuAcademicUnits/KMyb2rzG"],
        ["Animal Sciences - 1984/2013", "http://opaquenamespace.org/ns/osuAcademicUnits/EaDtECbp"],
        ["Animal and Rangeland Sciences - 2013/open", "http://opaquenamespace.org/ns/osuAcademicUnits/ZWAvMfi7"],
        ["4-H Youth Development Education - 2006/2010", "http://opaquenamespace.org/ns/osuAcademicUnits/5eh7OKFX"]
    ]
  end

  let(:test_sorted_all_options_truncated_values) do
    [
        "Accounting",
        "Animal Sciences",
        "Animal and Rangeland Sciences",
        "4-H Youth Development Education"
    ]
  end

  let(:test_sorted_current_options) do
    [
        ["Accounting - 1979/1992, 2009/open", "http://opaquenamespace.org/ns/osuAcademicUnits/KMyb2rzG"],
        ["Animal Sciences - 1984/2013", "http://opaquenamespace.org/ns/osuAcademicUnits/EaDtECbp"],
        ["Animal and Rangeland Sciences - 2013/open", "http://opaquenamespace.org/ns/osuAcademicUnits/ZWAvMfi7"],
    ]
  end

  let(:test_sorted_current_open_options) do
    [
        ["Accounting - 1979/1992, 2009/open", "http://opaquenamespace.org/ns/osuAcademicUnits/KMyb2rzG"],
        ["Animal and Rangeland Sciences - 2013/open", "http://opaquenamespace.org/ns/osuAcademicUnits/ZWAvMfi7"],
    ]
  end

  let(:test_sorted_current_open_options_truncated_values) do
    [
        "Accounting",
        "Animal and Rangeland Sciences"
    ]
  end

  before do
    allow(view).to receive(:signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:can?).and_return(true)
    allow_any_instance_of(ScholarsArchive::AcademicUnitsService).to receive(:select_sorted_all_options).and_return(test_sorted_all_options)
    allow_any_instance_of(ScholarsArchive::AcademicUnitsService).to receive(:select_sorted_current_options).and_return(test_sorted_current_options)
  end

  context "when user is admin" do
    let(:attributes) { { title: ["test"], creator: ["Blah"], rights_statement: ["blah.blah"], resource_type: ["blah"] } }

    before do
      allow(current_user).to receive(:admin?).and_return(true)
      assign(:form, form)
      render inline: form_template
    end

    it 'has the a select box with all available options' do
      expect(rendered).to have_select('graduate_thesis_or_dissertation_academic_affiliation', with_options: test_sorted_all_options_truncated_values)
    end
  end

  context "when user is not an admin" do
    let(:attributes) { { title: ["test"], creator: ["Blah"], rights_statement: ["blah.blah"], resource_type: ["blah"] } }

    before do
      allow(current_user).to receive(:admin?).and_return(false)
      assign(:form, form)
      render inline: form_template
    end

    it 'has the a select box with all available options' do
      expect(rendered).to have_select('graduate_thesis_or_dissertation_academic_affiliation', with_options: test_sorted_current_open_options_truncated_values)
    end
  end
end
