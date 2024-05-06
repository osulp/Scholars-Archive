# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdministrativeReportOrPublicationPresenter do
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
    AdministrativeReportOrPublication.new(
      id: '123abc',
      nested_ordered_title_attributes: nested_ordered_title_attributes,
      depositor: user.user_key,
      label: 'filename.tif')
  end
  let(:user) { double(user_key: 'sarah') }

  let(:solr_properties) do
    %w[doi abstract alternative_title license based_near_linked resource_type date_available date_copyright date_issued date_collected date_reviewed date_valid date_accepted replaces hydrologic_unit_code funding_body funding_statement in_series tableofcontents bibliographic_citation peerreviewed_label digitization_spec file_extent file_format dspace_community dspace_collection]
  end

  subject { presenter }

  it 'delegates to the solr_document' do
    solr_properties.each do |property|
      expect(solr_document).to receive(property.to_sym)
      presenter.send(property)
    end
  end

  it { is_expected.to delegate_method(:doi).to(:solr_document) }
  it { is_expected.to delegate_method(:abstract).to(:solr_document) }
  it { is_expected.to delegate_method(:alternative_title).to(:solr_document) }
  it { is_expected.to delegate_method(:license).to(:solr_document) }
  it { is_expected.to delegate_method(:based_near_linked).to(:solr_document) }
  it { is_expected.to delegate_method(:resource_type).to(:solr_document) }
  it { is_expected.to delegate_method(:date_available).to(:solr_document) }
  it { is_expected.to delegate_method(:date_copyright).to(:solr_document) }
  it { is_expected.to delegate_method(:date_issued).to(:solr_document) }
  it { is_expected.to delegate_method(:date_collected).to(:solr_document) }
  it { is_expected.to delegate_method(:date_reviewed).to(:solr_document) }
  it { is_expected.to delegate_method(:date_valid).to(:solr_document) }
  it { is_expected.to delegate_method(:date_accepted).to(:solr_document) }
  it { is_expected.to delegate_method(:replaces).to(:solr_document) }
  it { is_expected.to delegate_method(:hydrologic_unit_code).to(:solr_document) }
  it { is_expected.to delegate_method(:funding_body).to(:solr_document) }
  it { is_expected.to delegate_method(:funding_statement).to(:solr_document) }
  it { is_expected.to delegate_method(:in_series).to(:solr_document) }
  it { is_expected.to delegate_method(:tableofcontents).to(:solr_document) }
  it { is_expected.to delegate_method(:bibliographic_citation).to(:solr_document) }
  it { is_expected.to delegate_method(:peerreviewed_label).to(:solr_document) }
  it { is_expected.to delegate_method(:digitization_spec).to(:solr_document) }
  it { is_expected.to delegate_method(:file_extent).to(:solr_document) }
  it { is_expected.to delegate_method(:file_format).to(:solr_document) }
  it { is_expected.to delegate_method(:dspace_community).to(:solr_document) }
  it { is_expected.to delegate_method(:dspace_collection).to(:solr_document) }
end
