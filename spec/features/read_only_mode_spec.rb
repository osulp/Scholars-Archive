# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Read Only Mode', type: :feature do
  let(:user) do
    User.new(email: 'test@example.com', username: 'test', guest: false, api_person_updated_at: DateTime.now) { |u| u.save!(validate: false) }
  end

  context 'a logged in user' do
    before do
      login_as user
    end

    it 'View Articles Tabs', js: false do
      visit('/concern/articles/new')
      expect(page).to have_content('Add New Article')
      allow(Flipflop).to receive(:read_only?).and_return(true)
      visit('/concern/articles/new')
      expect(page).to have_content('This system is in read-only mode for maintenance.')
      allow(Flipflop).to receive(:read_only?).and_return(false)
      visit('/concern/articles/new')
      expect(page).to have_content('Add New Article')
    end
  end
end
