require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::LabelParserService do
  let(:labels) { ["label1$www.blah.com", "label2$www.blah.com"] }

  describe "#parse" do
    it "returns labels from a uri$label pair" do
      expect(described_class.parse(labels)).to eq ["label1", "label2"]
    end
  end
end
