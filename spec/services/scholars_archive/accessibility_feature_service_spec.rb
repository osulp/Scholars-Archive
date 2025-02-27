# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::AccessibilityFeatureService do
  let(:service) { described_class.new }

  describe '#select_active_options' do
    it 'returns active terms' do
      expect(service.select_active_options).to include(%w[annotations annotations], %w[alternativeText alternativeText], %w[taggedPDF taggedPDF], %w[openCaptions openCaptions])
    end
  end
end
