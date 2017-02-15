# Generated via
#  `rails generate hyrax:work Etd`
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Create a Etd' do
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
      visit new_curation_concerns_etd_path
      fill_in 'Title', with: 'Test Etd'
      click_button 'Create Etd'
      expect(page).to have_content 'Test Etd'
    end
  end
end
