require 'rails_helper'

RSpec.describe ArticlePresenter do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:ability) { double "Ability" }
  let(:presenter) { described_class.new(solr_document, ability) }
  let(:attributes) { file.to_solr }
  let(:file) do
    Article.new(
          id: '123abc',
          title: ["File title"],
          depositor: user.user_key,
          label: "filename.tif")
  end
  let(:user) { double(user_key: 'sarah')}
  let(:solr_properties) do
    ["resource_type", "editor", "has_volume", "has_number", "conference_location", "conference_name", "conference_section", "has_journal", "is_referenced_by", "isbn", "web_of_science_uid"]
  end
  subject { presenter }
  it "delegates to the solr_document" do
    solr_properties.each do |property|
      expect(solr_document).to receive(property.to_sym)
      presenter.send(property)
    end
  end

  it { is_expected.to delegate_method(:resource_type).to(:solr_document) }
  it { is_expected.to delegate_method(:editor).to(:solr_document) }
  it { is_expected.to delegate_method(:has_volume).to(:solr_document) }
  it { is_expected.to delegate_method(:has_number).to(:solr_document) }
  it { is_expected.to delegate_method(:conference_location).to(:solr_document) }
  it { is_expected.to delegate_method(:conference_name).to(:solr_document) }
  it { is_expected.to delegate_method(:conference_section).to(:solr_document) }
  it { is_expected.to delegate_method(:has_journal).to(:solr_document) }
  it { is_expected.to delegate_method(:is_referenced_by).to(:solr_document) }
  it { is_expected.to delegate_method(:isbn).to(:solr_document) }
  it { is_expected.to delegate_method(:web_of_science_uid).to(:solr_document) }
end
