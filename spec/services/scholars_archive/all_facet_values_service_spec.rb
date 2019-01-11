# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::AllFacetValuesService do
  let(:service) { described_class.new }
  let(:facet) { double('facet') }
  let(:facet_results) { %w[bob ross banana] }
  let(:solr_results) { {'bob' => 1, 'ross' => 1, 'banana' => 1} }
  let(:facet_key) { 'creator_sim' }

  describe '#call' do
    before do
      allow(facet).to receive(:key).and_return(facet_key)
      allow(service).to receive(:catalog_search_params).with(anything()).and_return({})
      allow(service).to receive(:solr_facets).with(anything(), anything()).and_return(solr_results)
    end
    it 'returns all unique creators in an array' do
      expect(service.call(facet, {})).to eq (facet_results)
    end
  end
end
