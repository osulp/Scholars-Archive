# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HonorsCollegeThesisPresenter do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:ability) { double 'Ability' }
  let(:presenter) { described_class.new(solr_document, ability) }
  let(:attributes) { file.to_solr }
  # let(:attributes) { file.attributes }
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

  subject { presenter }
  it 'delegates to the solr_document' do
    solr_properties.each do |property|
      # expect(presenter).to delegate_method(property).to(:solr_document)
      expect(solr_document).to receive(property.to_sym)
      presenter.send(property)
    end
  end
end
