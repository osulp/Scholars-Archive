# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe ScholarsArchive::LabelParserService do
  let(:labels) { ['label1$www.blah.com', 'label2$www.blah.com'] }

  describe '#parse' do
    it 'returns labels from a uri$label pair' do
      expect(described_class.parse(labels)).to eq %w[label1 label2]
    end
  end

  describe '#parse_label_uris' do
    context 'when label includes a special character $' do
      let(:labels) { ['label1 the cost is $200.00$www.blah.com', '$100.00$www.blah.com'] }

      it 'returns a hash of label and uri from a label$uri pair' do
        expect(described_class.parse_label_uris(labels)).to eq [{ 'label' => 'label1 the cost is $200.00', 'uri' => 'www.blah.com' }, { 'label' => '$100.00', 'uri' => 'www.blah.com' }]
      end
    end

    context 'when label does not include a special character $' do
      it 'returns a hash of label and uri from a label$uri pair' do
        expect(described_class.parse_label_uris(labels)).to eq [{ 'label' => 'label1', 'uri' => 'www.blah.com' }, { 'label' => 'label2', 'uri' => 'www.blah.com' }]
      end
    end
  end

  describe '#location_parse_uris' do
    let(:labels_linked) do
      ['Paris, Île-de-France, France, (Populated Place)$www.blah1.com',
       'Wé, Loyalty Islands, New Caledonia, (Populated Place)$www.blah2.com',
       'Eastern Africa, , (Area)$www.blah3.com']
    end

    it 'returns labels from a label$uri pair with the new parse location display' do
      expect(described_class.location_parse_uris(labels_linked)).to eq [{ 'label' => 'Paris, Île-de-France, France', 'uri' => 'www.blah1.com' },
                                                                        { 'label' => 'Wé, Loyalty Islands, New Caledonia', 'uri' => 'www.blah2.com' },
                                                                        { 'label' => 'Eastern Africa', 'uri' => 'www.blah3.com' }]
    end
  end

  describe '#location_parse_labels' do
    let(:labels_only) { ['Paris, Île-de-France, France, (Populated Place)', 'Wé, Loyalty Islands, New Caledonia, (Populated Place)', 'Eastern Africa, , (Area)'] }

    it 'returns labels from a label only with the new parse location display' do
      expect(described_class.location_parse_labels(labels_only)).to eq ['Paris, Île-de-France, France', 'Wé, Loyalty Islands, New Caledonia', 'Eastern Africa']
    end
  end

  describe '#string_parse' do
    let(:labels) { ['Paris', ' Île-de-France', ' France', ' (Populated Place)'] }

    it 'returns the labels array with the comma remove from string' do
      expect(described_class.string_parse(labels)).to eq 'Paris, Île-de-France, France'
    end
  end

  context 'with no labels supplied' do
    let(:labels) { nil }

    it 'returns an empty array of parsed labels' do
      expect(described_class.parse(labels)).to eq []
    end

    it 'returns an empty array of location_parse_uris' do
      expect(described_class.location_parse_uris(labels)).to eq []
    end

    it 'returns an empty array of location_parse_labels' do
      expect(described_class.location_parse_labels(labels)).to eq []
    end
  end
end
