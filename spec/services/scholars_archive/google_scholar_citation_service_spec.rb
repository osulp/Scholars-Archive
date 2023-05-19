# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::GoogleScholarCitationService do
  let(:service) { described_class }

  describe '#call' do
    context 'when formatting citation publication dates' do
      it 'returns a date in Y/m/d format when given in Y-m-d' do
        expect(service.call('2019-12-20')).to eq '2019/12/20'
      end

      it 'returns back an interval when given in Y-m-d/Y-m-d' do
        expect(service.call('2019-12-20/2019-12-21')).to eq '2019-12-20/2019-12-21'
      end

      it 'returns a from date in Y/m/d format when given in m/d/y' do
        expect(service.call('12/20/2019')).to eq '2019/12/20'
      end

      it 'returns empty string when given invalid date' do
        expect(service.call('invalid')).to be_empty
      end
    end
  end
end
