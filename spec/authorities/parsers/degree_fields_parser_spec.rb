# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Parsers::DegreeFieldsParser do
  let(:invalid_jsonld) {
  '{
  "@context": {
    "dc": "http://purl.org/dc/terms/",
    "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
    "skos": "http://www.w3.org/2004/02/skos/core#",
    "xsd": "http://www.w3.org/2001/XMLSchema#"
  },
  "@notgraph": [
    {
      "@id": "http://opaquenamespace.org/ns/osuDegreeFields",
      "@type": [
        "http://purl.org/dc/dcam/VocabularyEncodingScheme",
        "rdfs:Resource"
      ],
      "dc:issued": {
        "@value": "2017-08-03",
        "@type": "xsd:date"
      },
      "dc:modified": {
        "@value": "2017-00-03",
        "@type": "xsd:date"
      },
      "dc:title": {
        "@value": "Oregon State University Degree Fields",
        "@language": "en"
      },
      "rdfs:comment": {
        "@value": "These entities and date ranges were compiled from processed electronic theses and dissertations, and may contain gaps or other errors.",
        "@language": "en"
      }
    }]}'
  }

  let(:jsonld) {
  '{
  "@context": {
    "dc": "http://purl.org/dc/terms/",
    "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
    "skos": "http://www.w3.org/2004/02/skos/core#",
    "xsd": "http://www.w3.org/2001/XMLSchema#"
  },
  "@graph": [
    {
      "@id": "http://opaquenamespace.org/ns/osuDegreeFields",
      "@type": [
        "http://purl.org/dc/dcam/VocabularyEncodingScheme",
        "rdfs:Resource"
      ],
      "dc:issued": {
        "@value": "2017-08-03",
        "@type": "xsd:date"
      },
      "dc:modified": {
        "@value": "2017-00-03",
        "@type": "xsd:date"
      },
      "dc:title": {
        "@value": "Oregon State University Degree Fields",
        "@language": "en"
      },
      "rdfs:comment": {
        "@value": "These entities and date ranges were compiled from processed electronic theses and dissertations, and may contain gaps or other errors.",
        "@language": "en"
      }
    },
    {
      "@id": "http://opaquenamespace.org/ns/osuDegreeFields/HVWYADSR",
      "@type": [
        "skos:CorporateName",
        "rdfs:Resource"
      ],
      "dc:date": "2017",
      "dc:issued": {
        "@value": "2018-05-17",
        "@type": "xsd:date"
      },
      "dc:modified": {
        "@value": "2018-05-17",
        "@type": "xsd:date"
      },
      "rdfs:label": {
        "@value": "Accountancy",
        "@language": "en"
      }
    },
    {
      "@id": "http://opaquenamespace.org/ns/osuDegreeFields/TsB6Zk5J",
      "@type": [
        "skos:CorporateName",
        "rdfs:Resource"
      ],
      "dc:date": "{1973,1975..2017}",
      "dc:isReplacedBy": "http://opaquenamespace.org/ns/osuDegreeFields",
      "dc:issued": "2017-08-03",
      "dc:modified": {
        "@value": "2018-11-06",
        "@type": "xsd:date"
      },
      "rdfs:comment": {
        "@value": "This degree field is better represented using the Master of Arts in Interdisciplinary Studies (M.A.I.S.) degree name and specific degree fields.",
        "@language": "en"
      },
      "rdfs:label": {
        "@value": "Interdisciplinary Studies (M.A.I.S.)",
        "@language": "en"
      }
    }]}'
  }

  describe '#parse' do
    context 'when given JSON-LD without an invalid graph' do
      it 'raises the proper error' do
        expect(described_class.parse(invalid_jsonld)).to eq [{ id: 'invalid', term: 'invalid', active: true }]
      end
    end

    context 'when given JSONLD with a valid graph' do
      it 'parses the graph for id and labels' do
        expect(described_class.parse(jsonld)).to eq [{ id: 'http://opaquenamespace.org/ns/osuDegreeFields/HVWYADSR', term: 'Accountancy - 2017', active: true }]
      end
      it 'does not include deprecated terms' do
        expect(described_class.parse(jsonld)).not_to include 'http://opaquenamespace.org/ns/osuDegreeFields/TsB6Zk5J'
      end
    end
  end
end
