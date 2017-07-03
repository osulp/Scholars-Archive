require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::PeerreviewedService do
  let(:service) { described_class.new }

  describe "#select_active_options" do
    it "returns active terms" do
      expect(service.select_active_options).to include(["Yes", "TRUE"], ["No", "FALSE"])
    end
  end
end
