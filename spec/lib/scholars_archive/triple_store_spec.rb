require 'rails_helper'

describe ScholarsArchive::TripleStore do
  subject { described_class.new(url) }
  let(:url) { 'http://localhost:9999/blazegraph/namespace/test/sparql' }
  let(:klass) { RDF::Blazegraph::RestClient }
  let(:rdf_url) { 'http://opaquenamespace.org/ns/genus/Aphrodite' }
  let(:statements) do
    [
      RDF::Statement(RDF::URI('http://blah.blah/blah'), RDF::Vocab::DC.title, 'blah'),
      RDF::Statement(RDF::URI('http://blah.blah/blah'), RDF::Vocab::DC.relation, RDF::Node.new)
    ]
  end
  it "should initialize a triple store rest client" do
    expect(subject.url).to eq(url)
    expect(subject.client).to be_an_instance_of(klass)
  end

  context "with an existing RDF::Graph" do
    let(:graph) { RDF::Graph.new.insert(*statements) }
    it "should store the graph" do
      result = subject.store(graph)
      expect(result).to eq(graph)
    end
  end

  context "with a valid URI" do
    before :each do
      subject.fetch(rdf_url)
    end
    it "should return a graph" do
      graph = subject.fetch(rdf_url)
      expect(graph).to be_an_instance_of(RDF::Graph)
      expect(graph.to_a.size).to be > 1
    end
    it "should delete the graph" do
      expect(subject.delete(rdf_url)).to be_truthy
    end
  end

  context "with an invalid URI" do
    let(:rdf_url) { 'http://localhost:9999/bogusns/thisshouldntwork' }
    it "should raise an exception" do
      expect { subject.fetch(rdf_url) }.to raise_exception(ScholarsArchive::TripleStoreException)
    end
    it "should return true for nonexistent RDF delete" do
      expect(subject.delete(rdf_url)).to be_truthy
    end
  end

  context "with mocked RDF::Graph or class methods " do
    let(:graph) { RDF::Graph.new.insert(*statements) }
    before do
      allow(subject.client).to receive(:insert).and_raise("boo")
      allow(subject.client).to receive(:delete).and_raise("boo")
    end
    it "should raise an exception when trying to store" do
      expect { subject.store(graph) }.to raise_exception(ScholarsArchive::TripleStoreException)
    end
    it "should raise an exception when trying to delete" do
      expect { subject.delete(rdf_url) }.to raise_exception(ScholarsArchive::TripleStoreException)
    end
    describe "and malfunctioning triplestore" do
      before do
        allow(subject).to receive(:store).and_raise(ScholarsArchive::TripleStoreException, "boo")
      end
      it "should return the graph loaded from the source" do
        # call a private class method to test scenario wherein the triplestore
        # cache is malfunctioning and the source RDF is loaded
        g = subject.send(:fetch_and_cache_graph, rdf_url)
        expect(g).to be_an_instance_of(RDF::Graph)
      end
    end
  end
end
