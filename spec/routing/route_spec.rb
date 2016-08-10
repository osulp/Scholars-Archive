require 'rails_helper'

describe "stats routes", type: :routing do
  context "for works" do
    it 'routes to the controller' do
      expect(get: '/works/7/work_daily_stats').to route_to(controller: 'curation_concerns/generic_works', action: 'work_daily_stats', id: '7')
    end
    it 'builds a url' do
      expect(url_for(controller: 'curation_concerns/generic_works', action: 'work_daily_stats', id: '7', only_path: true)).to eql('/works/7/work_daily_stats')
    end
  end

  context "for files" do
    it 'routes to the controller' do
      expect(get: '/files/7/file_daily_stats').to route_to(controller: 'curation_concerns/file_sets', action: 'file_daily_stats', id: '7')
    end
    it 'builds a url' do
      expect(url_for(controller: 'curation_concerns/file_sets', action: 'file_daily_stats', id: '7', only_path: true)).to eql('/files/7/file_daily_stats')
    end
  end
end
