# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::LanguageService do
  let(:service) { described_class.new }

  describe '#all_labels' do
    it 'returns active terms' do
      expect(service.all_labels('http://id.loc.gov/vocabulary/iso639-2/eng')).to eq ['English [eng]']
    end
  end

  describe '#select_active_options' do
    it 'returns active terms' do
      expect(service.select_active_options.count).to eq 485
    end
  end
end
