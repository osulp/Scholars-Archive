# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::DegreeLevelService do
  let(:service) { described_class.new }

  describe '#select_active_options' do
    it 'returns active terms' do
      expect(service.select_active_options).to include(["Bachelor's", "Bachelor's"], %w[Certificate Certificate], %w[Doctoral Doctoral], ["Master's", "Master's"], %w[Other Other])
    end
  end
end
