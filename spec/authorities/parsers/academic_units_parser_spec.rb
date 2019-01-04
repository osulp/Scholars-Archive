# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Parsers::AcademicUnitsParser do
  let(:invalid_jsonld) do
    '{
    \'@context\': {
      \'dc\': \'http://purl.org/dc/terms/\',
      \'rdfs\': \'http://www.w3.org/2000/01/rdf-schema#\',
      \'skos\': \'http://www.w3.org/2004/02/skos/core#\',
      \'xsd\': \'http://www.w3.org/2001/XMLSchema#\'
    },
    \'@notgraph\': [
      {
        \'@id\': \'http://opaquenamespace.org/ns/osuAcademicUnits\',
        \'@type\': [
          \'http://purl.org/dc/dcam/VocabularyEncodingScheme\',
          \'rdfs:Resource\'
        ],
        \'dc:issued\': {
          \'@value\': \'2016-09-27\',
          \'@type\': \'xsd:date\'
        },
        \'dc:modified\': {
          \'@value\': \'2016-09-27\',
          \'@type\': \'xsd:date\'
        },
        \'dc:title\': {
          \'@value\': \'Oregon State University Academic Units\',
          \'@language\': \'en\'
        },
        \'rdfs:comment\': {
          \'@value\': \'Describing the colleges, schools, departments, and other academic units of Oregon State University, and their relationships with each other.\',
          \'@language\': \'en\'
        }
      },
      {
        \'@id\': \'http://opaquenamespace.org/ns/osuAcademicUnits/0Ct5bACm\',
        \'@type\': \'skos:CorporateName\',
        \'dc:date\': \'1904/1905, 1907/1919\',
        \'dc:issued\': {
          \'@value\': \'2017-03-28\',
          \'@type\': \'xsd:date\'
        },
        \'rdfs:label\': {
          \'@value\': \'Forestry\',
          \'@language\': \'en\'
        }
      }]}\'
  end
  let(:jsonld) do
    \'{
    \'@context\': {
      \'dc\': \'http://purl.org/dc/terms/\',
      \'rdfs\': \'http://www.w3.org/2000/01/rdf-schema#\',
      \'skos\': \'http://www.w3.org/2004/02/skos/core#\',
      \'xsd\': \'http://www.w3.org/2001/XMLSchema#\'
    },
    \'@graph\': [
      {
        \'@id\': \'http://opaquenamespace.org/ns/osuAcademicUnits\',
        \'@type\': [
          \'http://purl.org/dc/dcam/VocabularyEncodingScheme\',
          \'rdfs:Resource\'
        ],
        \'dc:issued\': {
          \'@value\': \'2016-09-27\',
          \'@type\': \'xsd:date\'
        },
        \'dc:modified\': {
          \'@value\': \'2016-09-27\',
          \'@type\': \'xsd:date\'
        },
        \'dc:title\': {
          \'@value\': \'Oregon State University Academic Units\',
          \'@language\': \'en\'
        },
        \'rdfs:comment\': {
          \'@value\': \'Describing the colleges, schools, departments, and other academic units of Oregon State University, and their relationships with each other.\',
          \'@language\': \'en\'
        }
      },
      {
        \'@id\': \'http://opaquenamespace.org/ns/osuAcademicUnits/0Ct5bACm\',
        \'@type\': \'skos:CorporateName\',
        \'dc:date\': \'1904/1905, 1907/1919\',
        \'dc:issued\': {
          \'@value\': \'2017-03-28\',
          \'@type\': \'xsd:date\'
        },
        \'rdfs:label\': {
          \'@value\': \'Forestry\',
          \'@language\': \'en\'
        }
      }]}'
  end

  describe '#parse' do
    context 'when givin JSONLD without a graph' do
      it 'raises the proper error' do
        expect(described_class.parse(invalid_jsonld)).to eq [{ id: 'invalid', term: 'invalid', active: true }]
      end
    end

    context 'when givin JSONLD without a graph' do
      it 'raises the proper error' do
        expect(described_class.parse(jsonld)).to eq [{ id: 'http://opaquenamespace.org/ns/osuAcademicUnits/0Ct5bACm', term: 'Forestry - 1904/1905, 1907/1919', active: true }]
      end
    end
  end
end
