# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Read Only Mode', type: :system, integration: true do
  let(:student) { create :user }

  context 'a logged in user' do
    before do
      login_as user
    end

    it 'View Etd Tabs', js: false do
      visit('/concern/articles/new')
      expect(page).to have_content('Submission Checklist')
      allow(Flipflop).to receive(:read_only?).and_return(true)
      visit('/concern/articles/new')
      expect(page).to have_content('This system is in read-only mode for maintenance.')
      allow(Flipflop).to receive(:read_only?).and_return(false)
      visit('/concern/articles/new')
      expect(page).to have_content('Submission Checklist')
    end
  end
end
