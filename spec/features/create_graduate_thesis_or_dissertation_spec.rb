# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Graduate Thesis Or Dissertation`
require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers

RSpec.feature 'Create a Graduate Thesis Or Dissertation', js: false do
  context 'a logged in user' do
    let(:user) do
      User.new(email: 'test@example.com', username: 'test', guest: false, api_person_updated_at: DateTime.now) { |u| u.save!(validate: false) }
    end
    let(:current_user) { user }

    let(:admin_set) do
      begin
        AdminSet.find('blah')
      rescue ActiveFedora::ObjectNotFoundError
        AdminSet.create(id: 'blah',
                        title: ['title'],
                        description: ['A substantial description'],
                        edit_users: ['admin'])
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
        ['Accounting - 1979/1992, 2009/open', 'http://opaquenamespace.org/ns/osuAcademicUnits/KMyb2rzG'],
        ['Animal Sciences - 1984/2013', 'http://opaquenamespace.org/ns/osuAcademicUnits/EaDtECbp']
      ]
    end
    let(:degree_field_sorted_all_options) do
      [
        ['Biological and Organic Chemistry - 1944', 'http://opaquenamespace.org/ns/osuDegreeFields/0ARiezTD'],
        ['Biochemistry - 1941, 1944/1952, 1965', 'http://opaquenamespace.org/ns/osuDegreeFields/0Kamj8EG']
      ]
    end

    before do
      Hyrax::PermissionTemplateAccess.create(permission_template: permission_template, agent_type: 'user', agent_id: 'admin', access: 'deposit')
      Sipity::WorkflowAction.create(id: 4, name: 'show', workflow_id: workflow.id)
      allow_any_instance_of(ApplicationHelper).to receive(:select_tag_dates).and_return('')
      allow_any_instance_of(Hyrax::DefaultForm).to receive(:date_terms).and_return([])
      allow_any_instance_of(ScholarsArchive::AcademicUnitsService).to receive(:select_sorted_all_options).and_return(academic_unit_sorted_all_options)
      allow_any_instance_of(ScholarsArchive::AcademicUnitsService).to receive(:select_sorted_current_options).and_return(academic_unit_sorted_all_options)
      allow_any_instance_of(ScholarsArchive::DegreeLevelService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ["Master's", "Master's"]])
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options).and_return([%w[Other Other], ['Zoology', 'http://opaquenamespace.org/ns/osuDegreeFields/k1QEWX4l']])
      allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ['Zoology', 'http://opaquenamespace.org/ns/osuDegreeFields/k1QEWX4l']])
      allow_any_instance_of(ScholarsArchive::DegreeNameService).to receive(:select_sorted_all_options).and_return([%w[Other Other], ['Master of Arts (M.A.)', 'Master of Arts (M.A.)']])
      allow_any_instance_of(ScholarsArchive::DegreeGrantorsService).to receive(:select_sorted_all_options).and_return([['Oregon State University', 'http://id.loc.gov/authorities/names/n80017721'], %w[Other Other]])
      allow_any_instance_of(ScholarsArchive::OtherAffiliationService).to receive(:select_sorted_all_options).and_return([['Honors College', 'http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege'], %w[Other Other]])
      allow_any_instance_of(ApplicationHelper).to receive(:select_tag_dates).and_return('')

      ENV['SCHOLARSARCHIVE_DEFAULT_ADMIN_SET'] = 'Test Default Admin Set'
      ENV['OSU_API_PERSON_REFRESH_SECONDS'] = '123456'
      @ticket = CASClient::ServiceTicket.new('ST-test', nil)
      @ticket.extra_attributes = { id: 10, email: 'admin@example.com' }
      @ticket.success = true
      @ticket.user = 'admin'

      Devise.cas_create_user = true
      User.authenticate_with_cas_ticket(@ticket)

      login_as user
      visit new_hyrax_graduate_thesis_or_dissertation_path
    end

    it 'renders the new form' do
      ordered_title_input = find(:css, 'input.nested-field.graduate_thesis_or_dissertation_nested_ordered_title')
      fill_in ordered_title_input[:id], with: 'Test Graduate Thesis Or Dissertation'

      creator_input = find(:css, 'input.nested-field.graduate_thesis_or_dissertation_nested_ordered_creator')
      fill_in creator_input[:id], with: 'Test Graduate Thesis Or Dissertation Creator'

      fill_in 'Commencement Year', with: '2018'

      select 'In Copyright', from: 'graduate_thesis_or_dissertation_rights_statement'
      find('body').click

      select 'Dissertation', from: 'graduate_thesis_or_dissertation_resource_type'
      find('body').click

      select "Master's", from: 'degree_level_select'
      find('body').click

      select 'Master of Arts (M.A.)', from: 'degree_name_sort'
      find('body').click

      select 'Zoology', from: 'graduate_thesis_or_dissertation_degree_field'
      find('body').click

      check 'agreement'

      click_link 'Files' # switch tab
      expect(page).to have_content 'Add files'
      within('#addfiles') do
        attach_file('files[]', File.join(Rails.root, '/spec/fixtures/files/world.png'))
      end

      choose('graduate_thesis_or_dissertation_visibility_open')

      expect(page).to have_content 'Add New Graduate Thesis Or Dissertation'
    end

    context 'sees default form values' do
      it 'default peerreviewed' do
        expect(page).to have_select('graduate_thesis_or_dissertation_peerreviewed', selected: 'No')
      end
    end
  end
end
