# Generated via
#  `rails generate hyrax:work Conference Proceedings Or Journal`
require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers

RSpec.feature 'Create a Conference Proceedings Or Journal', js: false do
  context 'a logged in user' do
    let(:user) { User.first }
    let(:current_user) { user }

    let(:admin_set) do
      begin
        AdminSet.find('blah')
      rescue ActiveFedora::ObjectNotFoundError
        AdminSet.create(id: 'blah',
                        title: ["title"],
                        description: ["A substantial description"],
                        edit_users: ["admin"])
      end
    end

    let(:permission_template) do
      Hyrax::PermissionTemplate.create!(source_id: admin_set.id)
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
      Hyrax::PermissionTemplateAccess.create(permission_template: permission_template, agent_type: 'user', agent_id: 'admin', access: 'deposit')
      Sipity::WorkflowAction.create(id: 4, name: 'show', workflow_id: workflow.id)
      allow_any_instance_of(ApplicationHelper).to receive(:select_tag_dates).and_return("")
      allow_any_instance_of(Hyrax::DefaultForm).to receive(:date_terms).and_return([])
      allow_any_instance_of(ScholarsArchive::AcademicUnitsService).to receive(:select_sorted_all_options).and_return(academic_unit_sorted_all_options)
      allow_any_instance_of(ScholarsArchive::AcademicUnitsService).to receive(:select_sorted_current_options).and_return(academic_unit_sorted_all_options)
      allow_any_instance_of(ScholarsArchive::DegreeLevelService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],["Bachelor's","Bachelor's"]])
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options).and_return([['Other', 'Other'],['Zoology','http://opaquenamespace.org/ns/osuDegreeFields/k1QEWX4l']])
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['Zoology','http://opaquenamespace.org/ns/osuDegreeFields/k1QEWX4l']])
      allow_any_instance_of(ScholarsArchive::DegreeNameService).to receive(:select_sorted_all_options).and_return([['Other', 'Other'],['Master of Arts (M.A.)','Master of Arts (M.A.)']])
      allow_any_instance_of(ScholarsArchive::DegreeGrantorsService).to receive(:select_sorted_all_options).and_return([['Oregon State University','http://id.loc.gov/authorities/names/n80017721'],['Other', 'Other']])
      allow_any_instance_of(ScholarsArchive::OtherAffiliationService).to receive(:select_sorted_all_options).and_return([['Honors College', 'http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege'],['Other', 'Other']])
      allow_any_instance_of(ApplicationHelper).to receive(:select_tag_dates).and_return("")

      ENV["SCHOLARSARCHIVE_DEFAULT_ADMIN_SET"] = 'Test Default Admin Set'

      @ticket = CASClient::ServiceTicket.new("ST-test", nil)
      @ticket.extra_attributes = {:id => 10, :email => "admin@example.com"}
      @ticket.success = true
      @ticket.user = "admin"

      Devise.cas_create_user = true
      User.authenticate_with_cas_ticket(@ticket)

      login_as user
      visit new_hyrax_conference_proceedings_or_journal_path
    end

    it "renders the new form" do
      fill_in 'conference_proceedings_or_journal_title', with: 'Test Conference Proceedings Or Journal'
      fill_in 'Creator', with: 'Test Conference Proceedings Or Journal Creator'

      select "In Copyright", :from => "conference_proceedings_or_journal_rights_statement"
      find('body').click

      select "Dissertation", :from => "conference_proceedings_or_journal_resource_type"
      find('body').click

      check 'agreement'

      click_link "Files" # switch tab
      within('span#addfiles') do
        attach_file("files[]", File.join(Rails.root, '/spec/fixtures/files/world.png'))
      end

      choose('conference_proceedings_or_journal_visibility_open')

      expect(page).to have_content "Add New Conference Proceedings Or Journal"
    end

    context "sees default form values" do
      it "default peerreviewed" do
        expect(page).to have_select('conference_proceedings_or_journal_peerreviewed', selected: 'No')
      end
    end
  end
end
