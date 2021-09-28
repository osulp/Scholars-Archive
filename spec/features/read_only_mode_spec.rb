require 'rails_helper'

include Warden::Test::Helpers

RSpec.feature 'Read Only Mode' do
  let(:student) { create :user }

  context 'a logged in user' do
    before do
      login_as student
    end

    scenario "View Etd Tabs", js: false do
      visit("/concern/etds/new")
      expect(page).to have_content("Submission Checklist")
      allow(Flipflop).to receive(:read_only?).and_return(true)
      visit("/concern/etds/new")
      expect(page).to have_content("This system is in read-only mode for maintenance.")
      allow(Flipflop).to receive(:read_only?).and_return(false)
      visit("/concern/etds/new")
      expect(page).to have_content("Submission Checklist")
    end
  end
end