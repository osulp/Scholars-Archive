# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::DegreeGrantorsService do
  let(:service) { described_class.new }

  describe '#select_sorted_all_options' do
    it 'returns the original term as well as non-admin terms' do
      expect(service.select_sorted_all_options('http://id.loc.gov/authorities/names/n82022628', false).count).to eq 3
    end

    it 'returns the the non-admin terms' do
      expect(service.select_sorted_all_options('NOTVALIDURLHERE', false).count).to eq 2
    end

    it 'returns all terms to admin user' do
      expect(service.select_sorted_all_options('http://id.loc.gov/authorities/names/n82022628', true).count).to eq 5
    end
  end
end
