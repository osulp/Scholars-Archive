# Generated via
#  `rails generate hyrax:work Eesc Publication`
require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers

RSpec.feature 'Create a Eesc Publication', skip: true, type: :feature do
  context 'a logged in user' do
    let(:user) do
      User.new(email: 'test@example.com',guest: false) { |u| u.save!(validate: false)}
    end

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

    before do
      Hyrax::PermissionTemplateAccess.create(permission_template: permission_template, agent_type: 'user', agent_id: user.user_key, access: 'deposit')
      Sipity::WorkflowAction.create(id: 4, name: 'show', workflow_id: workflow.id)
      login_as user
    end

    it do
      allow_any_instance_of(ApplicationHelper).to receive(:select_tag_dates).and_return("")
      allow_any_instance_of(Hyrax::DefaultWorkForm).to receive(:date_terms).and_return([])
      visit new_hyrax_etd_path
      choose 'Eesc Publication works'
      click_button 'Create work'
      fill_in 'Title', with: 'Test Eesc Publication'
      fill_in 'Creator', with: 'Test Eesc Publication Creator'
      fill_in 'Keyword', with: 'Test Eesc Publication Keyword'
      select "In Copyright", :from => "etd_rights_statement"
      check 'agreement'

      click_link "Files" # switch tab
      attach_file('files[]', File.join(Rails.root, '/spec/fixtures/files/world.png'))
      click_button 'Save'
      expect(page).to have_content 'Your files are being processed by Hyrax'
      visit '/dashboard/my/works/'
      expect(page).to have_content 'Test Eesc Publication'
    end
  end
end
