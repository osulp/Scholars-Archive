# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::LabelAndOrderedParserService do
  let(:labels) { ['label1$www.blah.com$0', 'label2$www.blah.com$1', 'label4$www.blah4.com$10', 'label3$www.blah3.com$2'] }

  describe '#parse' do
    it 'returns labels from a uri$label$index string' do
      expect(described_class.parse(labels)).to eq %w[label1 label2 label3 label4]
    end
  end

  describe '#parse_label_uris' do
    it 'returns a hash of label and uri from a uri$label$index string' do
      expect(described_class.parse_label_uris(labels)).to eq [{'label' => 'label1', 'uri' => 'www.blah.com', 'index' => '0'},
                                                              {'label' => 'label2', 'uri' => 'www.blah.com', 'index' => '1'},
                                                              {'label' => 'label3', 'uri' => 'www.blah3.com', 'index' => '2'},
                                                              {'label' => 'label4', 'uri' => 'www.blah4.com', 'index' => '10'}]
    end
  end

  context 'when label includes special character $' do
    let(:labels) { ['cost is $100.00$www.blah.com$0', '$10$www.blah.com$1'] }
    it 'returns a hash of label and uri from a label$uri pair' do
      expect(described_class.parse_label_uris(labels)).to eq [{'label' => 'cost is $100.00', 'uri' => 'www.blah.com', 'index' => '0'}, {'label' => '$10', 'uri' => 'www.blah.com', 'index' => '1'}]
    end
  end

  context 'with no labels supplied' do
    let(:labels) { nil }
    it 'returns an empty array of parsed labels' do
      expect(described_class.parse(labels)).to eq []
    end
  end
end
