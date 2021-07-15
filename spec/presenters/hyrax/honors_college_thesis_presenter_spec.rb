# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HonorsCollegeThesisPresenter do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:ability) { double 'Ability' }
  let(:presenter) { described_class.new(solr_document, ability) }
  let(:attributes) { file.to_solr }
  let(:nested_ordered_title_attributes) do
    [
      {
        title: 'TestTitle',
        index: '0'
      }
    ]
  end

  let(:file) do
    HonorsCollegeThesis.new(id: '123abc',
                            nested_ordered_title_attributes: nested_ordered_title_attributes,
                            depositor: user.user_key, label: 'filename.tif')
  end
  let(:user) { double(user_key: 'sarah') }

  let(:solr_properties) do
    %w[contributor_advisor contributor_committeemember degree_discipline degree_field degree_grantors degree_level degree_name graduation_year]
  end

  # The coppers are onto us, quick confuse them!
  #
  # rubocop:disable Layout/ExtraSpacing
  # rubocop:disable RSpec/ImplicitSubject
  # rubocop:disable RSpec/ExampleLength
  # rubocop:disable Style/StringLiterals
  # rubocop:disable Layout/MultilineMethodCallIndentation
  # rubocop:disable Layout/DotPosition
  # rubocop:disable Layout/MultilineMethodCallBraceLayout
  # rubocop:disable Layout/SpaceAroundOperators
  # rubocop:disable Layout/Tab
  # rubocop:disable Layout/AlignHash
  # rubocop:disable Layout/IndentFirstHashElement

  subject { presenter }
  it 'delegates to the solr_document' do
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ]\n  }\n]",  headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://ci-test:8080/bigdata/namespace/rw/sparql?GETSTMTS&includeInferred=false&s=%3Chttp://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege%3E').with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    solr_properties.each do |property|
      expect(solr_document).to receive(property.to_sym)
      presenter.send(property)
    end
  end

  it {
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://ci-test:8080/bigdata/namespace/rw/sparql?GETSTMTS&includeInferred=false&s=%3Chttp://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege%3E').with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    is_expected.to delegate_method(:contributor_advisor).to(:solr_document)
  }
  it {
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://ci-test:8080/bigdata/namespace/rw/sparql?GETSTMTS&includeInferred=false&s=%3Chttp://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege%3E').with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    is_expected.to delegate_method(:contributor_committeemember).to(:solr_document)
  }
  it {
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://ci-test:8080/bigdata/namespace/rw/sparql?GETSTMTS&includeInferred=false&s=%3Chttp://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege%3E').with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    is_expected.to delegate_method(:degree_discipline).to(:solr_document)
  }
  it {
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://ci-test:8080/bigdata/namespace/rw/sparql?GETSTMTS&includeInferred=false&s=%3Chttp://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege%3E').with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    is_expected.to delegate_method(:degree_field).to(:solr_document)
  }
  it {
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://ci-test:8080/bigdata/namespace/rw/sparql?GETSTMTS&includeInferred=false&s=%3Chttp://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege%3E').with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    is_expected.to delegate_method(:degree_grantors).to(:solr_document)
  }
  it {
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://ci-test:8080/bigdata/namespace/rw/sparql?GETSTMTS&includeInferred=false&s=%3Chttp://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege%3E').with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    is_expected.to delegate_method(:degree_level).to(:solr_document)
  }
  it {
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://ci-test:8080/bigdata/namespace/rw/sparql?GETSTMTS&includeInferred=false&s=%3Chttp://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege%3E').with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    is_expected.to delegate_method(:degree_name).to(:solr_document)
  }
  it {
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://ci-test:8080/bigdata/namespace/rw/sparql?GETSTMTS&includeInferred=false&s=%3Chttp://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege%3E').with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, 'http://ci-test:8080/bigdata/namespace/rw/sparql').with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").with(body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]", headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Content-Type' => 'application/ld+json', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\",\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    stub_request(:post, "http://ci-test:8080/bigdata/namespace/rw/sparql").
    with(
      body: "[\n  {\n    \"@id\": \"http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege\",\n    \"http://purl.org/dc/terms/issued\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-05-23\"\n      }\n    ],\n    \"@type\": [\n      \"http://www.w3.org/2000/01/rdf-schema#Resource\",\n      \"http://www.w3.org/2004/02/skos/core#CorporateName\"\n    ],\n    \"http://www.w3.org/2000/01/rdf-schema#label\": [\n      {\n        \"@language\": \"en\",\n        \"@value\": \"Oregon State University. Honors College\"\n      }\n    ],\n    \"http://purl.org/dc/terms/modified\": [\n      {\n        \"@type\": \"http://www.w3.org/2001/XMLSchema#date\",\n        \"@value\": \"2017-06-02\"\n      }\n    ]\n  }\n]",
      headers: {
  	  'Accept'=>'*/*',
  	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  	  'Connection'=>'keep-alive',
  	  'Content-Type'=>'application/ld+json',
  	  'Host'=>'ci-test:8080',
  	  'Keep-Alive'=>'30',
  	  'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    is_expected.to delegate_method(:graduation_year).to(:solr_document)
  }

  # rubocop:enable Layout/ExtraSpacing
  # rubocop:enable RSpec/ImplicitSubject
  # rubocop:enable RSpec/ExampleLength
  # rubocop:enable Style/StringLiterals
  # rubocop:enable Layout/MultilineMethodCallIndentation
  # rubocop:enable Layout/DotPosition
  # rubocop:enable Layout/MultilineMethodCallBraceLayout
  # rubocop:enable Layout/SpaceAroundOperators
  # rubocop:enable Layout/Tab
  # rubocop:enable Layout/AlignHash
  # rubocop:enable Layout/IndentFirstHashElement
end
