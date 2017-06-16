require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::DegreeFieldService do
  let(:service) { described_class.new }

  describe '#select_active_options' do
    it 'returns active terms' do
      expect(service.select_active_options).to include(['Adult Education', 'Adult Education'], ['Aeronautical Engineering', 'Aeronautical Engineering'], %w(Zoology Zoology))
    end
  end
end
