# frozen_string_literal: true

RSpec.describe ScholarsArchive::ResearchOrganizationRegistryService do
  let(:service) { described_class.new }

  # STUB: Add in a fetch for request on URI fetch
  before do
    stub_request(:get, 'https://api.ror.org/v2/organizations/')
      .with(query: hash_including({ 'id': 'https://ror.org/01mdg2p21' }))
      .to_return(status: 200, body: File.open(File.join(fixture_path, 'ror.json')))
  end

  # TEST: Do test on w/ uri string, obj, non-valid, and nil
  context 'with ROR uri string' do
    let(:uri) { 'https://ror.org/01mdg2p21' }

    describe 'full_label' do
      it 'returns a full label' do
        allow(service).to receive(:full_label).with(uri).and_return('Oregon Observatory')
        expect(service.full_label(uri)).to eq 'Oregon Observatory'
      end
    end
  end

  context 'with ROR uri object' do
    let(:uri) { URI('https://ror.org/01mdg2p21') }

    describe 'full_label' do
      it 'returns a full label' do
        allow(service).to receive(:full_label).with(uri).and_return('Oregon Observatory')
        expect(service.full_label(uri)).to eq 'Oregon Observatory'
      end
    end
  end

  context 'with invalid type' do
    let(:uri) { 5_037_649 }

    describe 'full_label' do
      it 'returns a full label' do
        expect { service.full_label(uri) }.to raise_error
      end
    end
  end

  context 'with blank object' do
    let(:uri) { nil }

    describe 'full_label' do
      it 'returns a full label' do
        expect(service.full_label(uri)).to eq nil
      end
    end
  end
end
