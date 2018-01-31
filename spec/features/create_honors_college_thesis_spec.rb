# Generated via
#  `rails generate hyrax:work Honors College Thesis`
require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers

RSpec.feature 'Create a Honors College Thesis', type: :feature do
  context 'a logged in user' do
    let(:user) do
      User.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false)}
    end
    let(:current_user) { user }

    let(:admin_set) do
      AdminSet.create(title: ["A completely unique name"],
             description: ["A substantial description"],
             edit_users: [user.user_key])
    end

    let(:permission_template) do
      Hyrax::PermissionTemplate.create!(admin_set_id: admin_set.id)
    end

    let(:workflow) do
      Sipity::Workflow.create(name: 'test', allows_access_grant: true, active: true, permission_template_id: permission_template.id)
    end

    let(:academic_unit_sorted_all_options) do
      [
          ["Accounting - 1979/1992, 2009/open", "http://opaquenamespace.org/ns/osuAcademicUnits/KMyb2rzG"],
          ["Animal Sciences - 1984/2013", "http://opaquenamespace.org/ns/osuAcademicUnits/EaDtECbp"],
      ]
    end
    let(:degree_field_sorted_all_options) do
      [
          ["Biological and Organic Chemistry - 1944", "http://opaquenamespace.org/ns/osuDegreeFields/0ARiezTD"],
          ["Biochemistry - 1941, 1944/1952, 1965", "http://opaquenamespace.org/ns/osuDegreeFields/0Kamj8EG"],
      ]
    end

    before do
      Hyrax::PermissionTemplateAccess.create(permission_template: permission_template, agent_type: 'user', agent_id: user.user_key, access: 'deposit')
      Sipity::WorkflowAction.create(id: 4, name: 'show', workflow_id: workflow.id)
      allow_any_instance_of(ApplicationHelper).to receive(:select_tag_dates).and_return("")
      allow_any_instance_of(Hyrax::DefaultForm).to receive(:date_terms).and_return([])
      allow_any_instance_of(ScholarsArchive::AcademicUnitsService).to receive(:select_sorted_all_options).and_return(academic_unit_sorted_all_options)
      allow_any_instance_of(ScholarsArchive::AcademicUnitsService).to receive(:select_sorted_current_options).and_return(academic_unit_sorted_all_options)
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return(degree_field_sorted_all_options)
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options).and_return(degree_field_sorted_all_options)
#      allow(controller).to receive(:current_user).and_return(current_user)

      login_as user

      visit new_hyrax_honors_college_thesis_path
      choose 'Honors College Thesis works'
      click_button 'Create work'
    end

    it "creates a new work" do
      fill_in 'Title', with: 'Test Honors College Thesis'
      fill_in 'Creator', with: 'Test Honors College Thesis Creator'
      fill_in 'Keyword', with: 'Test Honors College Thesis Keyword'

      select "In Copyright", :from => "honors_college_thesis_rights_statement"
      check 'agreement'

      click_link "Files" # switch tab
      attach_file('files[]', File.join(Rails.root, '/spec/fixtures/files/world.png'))
      click_button 'Save'
      expect(page).to have_content 'Your files are being processed by Hyrax'
      visit '/dashboard/my/works/'
      expect(page).to have_content 'Test Honors College Thesis'
    end

    context "sees default form values" do
      it "default resource type" do
        expect(page).to have_select('honors_college_thesis_resource_type', selected: 'Honors College Thesis')
      end
      it "default non-academic affiliation" do
        expect(page).to have_content(["http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege"])
      end
    end
  end
end
