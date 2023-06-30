# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::EdtfDateCompareService do
  let(:active_option) { ['Accounting - 1979/1992, 2009/open', 'http://opaquenamespace.org/ns/osuAcademicUnits/KMyb2rzG'] }

  before do
    allow(Date).to receive(:today).and_return Date.new(2017, 10, 8)
  end

  describe '#includes_open_dates?' do
    it 'includes only active_options in the last five years and are open' do
      expect(described_class.includes_open_dates?(active_option)).to eq true
    end
  end

  context 'when date is in the last five years and not open' do
    let(:active_option) { ['Animal Sciences - 1984/2013', 'http://opaquenamespace.org/ns/osuAcademicUnits/EaDtECbp'] }

    it 'should not include the option in the list' do
      expect(described_class.includes_open_dates?(active_option)).to eq false
    end
  end

  context 'when date is in the last five years and is open' do
    let(:active_option) { ['Animal and Rangeland Sciences - 2013/open', 'http://opaquenamespace.org/ns/osuAcademicUnits/ZWAvMfi7'] }

    it 'it should include the option in the list' do
      expect(described_class.includes_open_dates?(active_option)).to eq true
    end
  end

  context 'when date is not in the last five years' do
    let(:active_option) { ['4-H Youth Development Education - 2006/2010', 'http://opaquenamespace.org/ns/osuAcademicUnits/5eh7OKFX'] }

    it 'should not include the option in the list' do
      expect(described_class.includes_open_dates?(active_option)).to eq false
    end
  end
end
