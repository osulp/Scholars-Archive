require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::OrderedParserService do
  let(:labels) { ["ordered_creator_1$1", "ordered_creator_3$3", "ordered_creator_2$2"] }

  describe "#parse" do
    it "returns labels ordered by index" do
      expect(described_class.parse(labels)).to eq ["ordered_creator_1", "ordered_creator_2", "ordered_creator_3"]
    end
  end
end
