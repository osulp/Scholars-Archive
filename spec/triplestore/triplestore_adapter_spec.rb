require 'rails_helper'

RSpec.describe TriplestoreAdapter do
  let(:triplestore) { TriplestoreAdapter::Triplestore.new(triplestore_client)}
  let(:triplestore_client) { TriplestoreAdapter::Client.new(Settings.triplestore_adapter.type, Settings.triplestore_adapter.url)}

  describe "having a valid configuration" do
    it "should instantiate the triplestore_adapter" do
      expect(triplestore.client).not_to be_nil
      expect(triplestore.client.url).to eq(Settings.triplestore_adapter.url)
    end
  end
  describe "having an invalid configuration" do
    let(:triplestore_client) { TriplestoreAdapter::Client.new('', '')}
    it "should raise an exception and not instantiate the triplestore_adapter" do
      expect{ triplestore.client }.to raise_error(TriplestoreAdapter::TriplestoreException)
    end
  end
end