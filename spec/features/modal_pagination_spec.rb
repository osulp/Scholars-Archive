# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers

RSpec.describe 'Modal facet pagination', type: :feature, clean_repo: true do
  let!(:lots_of_works) do
    # Generate a bunch of works so that the pagination will show multiple pages
    works = []
    subjects = []
    (10..19).each do |i|
      subjects << "research#{i}subject"
    end
    nested_ordered_title_attributes = [
      {
        title: 'TestTitle1',
        index: '0'
      }
    ]
    w = Default.new do |work|
      work.subject << subjects
      work.apply_depositor_metadata('jilluser')
      work.read_groups = ['public']
      work.nested_ordered_title_attributes = nested_ordered_title_attributes
    end
    w.save!
    works << w
    subjects = []
    (20..30).each do |i|
      subjects << "research#{i}subject"
    end
    nested_ordered_title_attributes.first[:title] = 'TestTitle2'
    w = Default.new do |work|
      work.subject << subjects
      work.apply_depositor_metadata('jilluser')
      work.read_groups = ['public']
      work.nested_ordered_title_attributes = nested_ordered_title_attributes
    end
    w.save!
    works << w
  end

  before do
    visit '/'
    allow_any_instance_of(ApplicationHelper).to receive(:max_page_number).with(anything(), anything(), anything()).and_return(2)
    # allow_any_instance_of(SearchBuilder).to receive(:facet_limit_with_pagination).with(anything()).and_return(2)
  end

  describe 'when searching the catalog' do
    it 'using facet pagination to browse by subjects' do
      click_button 'search-submit-header'

      expect(page).to have_content 'Search Results'
      expect(page).to have_content lots_of_works.first.nested_ordered_title.first.title.first
      expect(page).to have_content lots_of_works.second.nested_ordered_title.first.title.first

      click_link 'Subject'
      click_link 'more Subjects »'
      within('.bottom') do
        click_link '2'
      end

      within('.modal-body') do
        expect(page).not_to have_content lots_of_works.first.subject.first
        expect(page).to have_content lots_of_works[1].subject.max

        click_link lots_of_works[1].subject.max
      end

      expect(page).to have_content lots_of_works[1].nested_ordered_title.first.title.first
      expect(page).not_to have_content lots_of_works.first.nested_ordered_title.first.title.first
    end
  end
end
