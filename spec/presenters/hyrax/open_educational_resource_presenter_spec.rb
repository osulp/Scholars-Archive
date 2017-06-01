require 'rails_helper'

RSpec.describe OpenEducationalResourcePresenter do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:ability) { double "Ability" }
  let(:presenter) { described_class.new(solr_document, ability) }
  let(:attributes) { file.to_solr }
  let(:file) do
    OpenEducationalResource.new(
          id: '123abc',
          title: ["File title"],
          depositor: user.user_key,
          label: "filename.tif")
  end
  let(:user) { double(user_key: 'sarah')}

  let(:solr_properties) do
    ["is_based_on_url", "interactivity_type", "learning_resource_type", "typical_age_range", "time_required"]
  end
  subject { presenter }
  it "delegates to the solr_document" do
    solr_properties.each do |property|
      expect(solr_document).to receive(property.to_sym)
      presenter.send(property)
    end
  end

  it { is_expected.to delegate_method(:time_required).to(:solr_document) }
  it { is_expected.to delegate_method(:typical_age_range).to(:solr_document) }
  it { is_expected.to delegate_method(:learning_resource_type).to(:solr_document) }
  it { is_expected.to delegate_method(:interactivity_type).to(:solr_document) }
  it { is_expected.to delegate_method(:is_based_on_url).to(:solr_document) }
end
