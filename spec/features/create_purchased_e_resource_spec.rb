# Generated via
#  `rails generate hyrax:work PurchasedEResource`
require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a PurchasedEResource', skip: true, type: :feature, js: false do
  context 'a logged in user' do

    let(:user) do
      User.new(email: 'test@example.com',guest: false) { |u| u.save!(validate: false)}
    end

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

    before do
      Hyrax::PermissionTemplateAccess.create(permission_template: permission_template, agent_type: 'user', agent_id: user.user_key, access: 'deposit')
      Sipity::WorkflowAction.create(id: 4, name: 'show', workflow_id: workflow.id)
      login_as user
    end

    it do
      allow_any_instance_of(ApplicationHelper).to receive(:select_tag_dates).and_return("")
      visit new_hyrax_purchased_e_resource_path
      choose 'PurchasedEResource works'
      click_button 'Create work'
      fill_in 'Title', with: 'Test eresource'
      fill_in 'Creator', with: 'Test eresource Creator'
      fill_in 'Keyword', with: 'Test eresource Keyword'
      check 'agreement'

      click_link "Files" # switch tab
      attach_file('files[]', File.join(Rails.root, '/spec/fixtures/files/world.png'))
      click_button 'Save'
      expect(page).to have_content 'Your files are being processed by Hyrax'
      visit '/dashboard/my/works/'
      expect(page).to have_content 'Test eresource'
    end
  end
end
