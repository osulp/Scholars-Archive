# frozen_string_literal: true

RSpec.describe ScholarsArchive::AcademicAffiliationService do
  let(:service) { described_class.new }

  # STUB: Add in a fetch for request on URI fetch
  before do
    stub_request(:get, 'https://opaquenamespace.org/ns/osuAcademicUnits/')
      .with(query: hash_including({ 'id': 'https://opaquenamespace.org/ns/osuAcademicUnits/0VDmN3pS' }))
      .to_return(status: 200, body: File.open(File.join(fixture_path, 'academic_affiliation.json')))
  end

  # TEST: Do test on w/ uri string, obj, non-valid, and nil
  context 'with academic affiliation uri string' do
    let(:uri) { 'https://opaquenamespace.org/ns/osuAcademicUnits/0VDmN3pS' }

    describe 'full_label' do
      it 'returns a full label' do
        allow(service).to receive(:full_label).with(uri).and_return('Pharmacy Administration')
        expect(service.full_label(uri)).to eq 'Pharmacy Administration'
      end
    end
  end

  context 'with academic affiliation uri object' do
    let(:uri) { URI('https://opaquenamespace.org/ns/osuAcademicUnits/0VDmN3pS') }

    describe 'full_label' do
      it 'returns a full label' do
        allow(service).to receive(:full_label).with(uri).and_return('Pharmacy Administration')
        expect(service.full_label(uri)).to eq 'Pharmacy Administration'
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
