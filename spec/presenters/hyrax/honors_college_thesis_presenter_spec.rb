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

  # CCI stub_request
  stub_request(:get, "http://ci-test:8080/bigdata/namespace/rw/sparql?GETSTMTS&includeInferred=false&s=%3Chttp://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege%3E").with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby'}).to_return(status: 200, body: "", headers: {})

  let(:file) do
    HonorsCollegeThesis.new(id: '123abc',
                            nested_ordered_title_attributes: nested_ordered_title_attributes,
                            depositor: user.user_key, label: 'filename.tif')
  end
  let(:user) { double(user_key: 'sarah') }

  let(:solr_properties) do
    %w[contributor_advisor contributor_committeemember degree_discipline degree_field degree_grantors degree_level degree_name graduation_year]
  end
  subject { presenter }
  it 'delegates to the solr_document' do
    solr_properties.each do |property|
      expect(solr_document).to receive(property.to_sym)
      presenter.send(property)
    end
  end

  it { is_expected.to delegate_method(:contributor_advisor).to(:solr_document) }
  it { is_expected.to delegate_method(:contributor_committeemember).to(:solr_document) }
  it { is_expected.to delegate_method(:degree_discipline).to(:solr_document) }
  it { is_expected.to delegate_method(:degree_field).to(:solr_document) }
  it { is_expected.to delegate_method(:degree_grantors).to(:solr_document) }
  it { is_expected.to delegate_method(:degree_level).to(:solr_document) }
  it { is_expected.to delegate_method(:degree_name).to(:solr_document) }
  it { is_expected.to delegate_method(:graduation_year).to(:solr_document) }
end
