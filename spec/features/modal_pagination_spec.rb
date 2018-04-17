require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers

# Feature test needs net connect for docker-stack capability
WebMock.allow_net_connect!

RSpec.describe "Modal facet pagination", type: :feature, clean_repo: true do
  let!(:lots_of_works) do
    # Generate a bunch of works so that the pagination will show multiple pages
    works = []
    (1..26).each do |i|
      works << Default.new do |work|
        work.title = ["Research#{i}"]
        work.subject << ["research#{i}subject"]
        work.apply_depositor_metadata('jilluser')
        work.read_groups = ['public']
        work.save!
      end
    end
    works
  end

  before do
    visit '/'
  end

  describe 'when searching the catalog' do
    it 'using facet pagination to browse by subjects' do
      click_button "search-submit-header"

      expect(page).to have_content 'Search Results'
      expect(page).to have_content lots_of_works.first.title.first
      expect(page).to have_content lots_of_works.second.title.first

      click_link "Subject"
      click_link "more Subjects »"
      within('.bottom') do
        click_link '2'
      end

      within(".modal-body") do
        expect(page).not_to have_content lots_of_works.first.subject.first
        expect(page).to have_content lots_of_works[7].subject.first

        click_link lots_of_works[7].subject.first
      end

      expect(page).to have_content lots_of_works[7].title.first
      expect(page).not_to have_content lots_of_works.first.title.first
    end
  end
end
