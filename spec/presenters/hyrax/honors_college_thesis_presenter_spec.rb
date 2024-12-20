# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HonorsCollegeThesisPresenter do
  subject { presenter }

  let(:solr_document) { SolrDocument.new(attributes) }
  let(:ability) { double 'Ability' }
  let(:presenter) { described_class.new(solr_document, ability) }
  let(:attributes) { file.attributes }
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
    %i[contributor_advisor contributor_committeemember degree_discipline degree_field degree_grantors degree_level degree_name graduation_year]
  end

  it 'delegates to the solr_document' do
    solr_properties.each do |property|
      expect(presenter).to delegate_method(property).to(:solr_document)
    end
  end
end
