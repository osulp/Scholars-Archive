# Generated via
#  `rails generate hyrax:work DefaultWork`
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Create a DefaultWork' do
  context 'a logged in user' do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end
    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    before do
      login_as user
    end

    scenario do
      visit new_curation_concerns_default_work_path
      fill_in 'Title', with: 'Test DefaultWork'
      click_button 'Create DefaultWork'
      expect(page).to have_content 'Test DefaultWork'
    end
  end
end
