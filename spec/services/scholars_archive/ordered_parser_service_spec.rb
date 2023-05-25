# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::OrderedParserService do
  let(:labels) { ['ordered_creator_1$1', 'ordered_creator_3$3', 'ordered_creator_2$2', 'ordered_creator_11$11', 'ordered_creator_10$10'] }

  describe '#parse' do
    it 'returns labels ordered by index' do
      expect(described_class.parse(labels)).to eq %w[ordered_creator_1 ordered_creator_2 ordered_creator_3 ordered_creator_10 ordered_creator_11]
    end

    context 'when label includes a special character $' do
      let(:labels) { ['label1 the cost is $200.00$0', '$100.00$1'] }

      it 'returns a hash of label and index from a label$index pair' do
        expect(described_class.parse(labels)).to eq ['label1 the cost is $200.00', '$100.00']
      end
    end
  end
end
