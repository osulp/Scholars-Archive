require 'rails_helper'

describe "Generic File" do
  context 'edit form', :type => :feature do

    let(:user) { User.create(:username => 'blah', :email => 'noreply@oregonstate.edu', :group_list => "admin") }
    let!(:file) do
      ::GenericFile.new.tap do |f|
        f.title = ['little_file.txt']
        f.creator = ['little_file.txt_creator']
        f.resource_type = ["stuff" ]
        f.read_groups = ['public']
        f.apply_depositor_metadata(user.user_key)
        f.save!
      end
    end

    before :each do
      login_as user, :scope => :user
      visit "/dashboard/files"
      within("#document_#{file.id}") do
        click_button "Select an action"
        click_link "Edit File"
      end
    end

    it "should allow for setting an embargo with CCID protected after embargo state" do
      click_link 'Permissions'
      choose 'visibility_embargo'
      select 'Private', from: 'visibility_during_embargo'
      select 'Oregon State University', from: 'visibility_after_embargo'
      fill_in 'embargo_release_date', with: '2020-01-01'
      click_button 'Save'
      visit "/files/#{file.id}/edit"
      expect(page).to have_content "Private"
      expect(file.reload).to be_under_embargo
    end

  end
end
