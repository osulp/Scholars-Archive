# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe ScholarsArchive::LocationLabelParserService do
  let(:labels_linked) do
    [{ 'label' => 'Paris, Île-de-France, France, (Populated Place)', 'uri' => 'www.blah1.com' },
     { 'label' => 'Wé, Loyalty Islands, New Caledonia, (Populated Place)', 'uri' => 'www.blah2.com' },
     { 'label' => 'Eastern Africa, , (Area)', 'uri' => 'www.blah3.com' }]
  end

  let(:labels_only) { ['Paris, Île-de-France, France, (Populated Place)', 'Wé, Loyalty Islands, New Caledonia, (Populated Place)', 'Eastern Africa, , (Area)'] }

  describe '#location_parse_uris' do
    it 'returns labels from a label$uri pair with the new parse location display' do
      expect(described_class.location_parse_uris(labels_linked)).to eq [{ 'label' => 'Paris, Île-de-France, France', 'uri' => 'www.blah1.com' },
                                                                        { 'label' => 'Wé, Loyalty Islands, New Caledonia', 'uri' => 'www.blah2.com' },
                                                                        { 'label' => 'Eastern Africa', 'uri' => 'www.blah3.com' }]
    end
  end

  describe '#location_parse_labels' do
    it 'returns labels from a label only with the new parse location display' do
      expect(described_class.location_parse_labels(labels_only)).to eq ['Paris, Île-de-France, France', 'Wé, Loyalty Islands, New Caledonia', 'Eastern Africa']
    end
  end

  describe '#string_parse' do
    let(:labels) { ['Paris', ' Île-de-France', ' France', ' (Populated Place)'] }

    it 'returns the labels array with the comma remove from string' do
      expect(described_class.new.string_parse(labels)).to eq 'Paris, Île-de-France, France'
    end
  end

  context 'with no labels supplied' do
    let(:labels_nil) { nil }

    it 'returns an empty array of location_parse_uris' do
      expect(described_class.location_parse_uris(labels_nil)).to eq []
    end

    it 'returns an empty array of location_parse_labels' do
      expect(described_class.location_parse_labels(labels_nil)).to eq []
    end
  end
end
