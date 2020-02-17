# frozen_string_literal: true

require 'rails_helper'
RSpec.describe FetchFailedGraphWorker, type: :worker do
  let(:worker) { described_class.new }
  let(:uri) { 'http://my.queryuri.com' }
  let(:user) { build(:user) }
  let(:model) { create(:generic, title: ['foo'], based_near: [controlled_val], depositor: user.email, id: 123) }
  let(:controlled_val) { Hyrax::ControlledVocabularies::Location.new('http://opaquenamespace.org/ns/creator/ChabreWayne') }
  let(:work) { model }
  let(:controlled_prop) { :based_near }
  let(:headers) { { headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix' } } }

  describe '#perform' do
    context 'when the request works' do
      before do
        allow(controlled_val).to receive(:fetch).with(headers).and_return({})
        allow(controlled_val).to receive(:solrize).and_return(['http://opaquenamespace.org/ns/creator/ChabreWayne', { label: 'Chabre, Wayne$http://opaquenamespace.org/ns/creator/ChabreWayne' }])
        stub_request(:get, 'http://ci-test:8080/bigdata/namespace/rw/sparql?GETSTMTS&includeInferred=false&s=%3Chttp://opaquenamespace.org/ns/creator/ChabreWayne%3E').with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
        stub_request(:get, 'http://opaquenamespace.org/ns/creator/ChabreWayne').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix, */*;q=0.1', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Ruby RDF.rb/3.1.1' }).to_return(status: 200, body: '', headers: {})
        stub_request(:get, 'http://opaquenamespace.org/ns/creator/ChabreWayne').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix, */*;q=0.1', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Ruby RDF.rb/3.0.13' }).to_return(status: 200, body: '', headers: {})
      end

      it 'fetches a work and indexes its linked data labels' do
        worker.perform(work.id, controlled_val, controlled_prop)
        expect(SolrDocument.find(work.id)['creator_label_tesim'].first).to eq 'Chabre, Wayne'
      end
    end

    context 'when the request fails' do
      before do
        allow(controlled_val).to receive(:fetch).with(headers).and_raise(TriplestoreAdapter::TriplestoreException)
        allow(controlled_val).to receive(:solrize).and_return(['http://opaquenamespace.org/ns/creator/ChabreWayne', { label: 'Chabre, Wayne$http://opaquenamespace.org/ns/creator/ChabreWayne' }])
        stub_request(:get, 'http://ci-test:8080/bigdata/namespace/rw/sparql?GETSTMTS&includeInferred=false&s=%3Chttp://opaquenamespace.org/ns/creator/ChabreWayne%3E').with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 500, body: '', headers: {})
        stub_request(:get, 'http://opaquenamespace.org/ns/creator/ChabreWayne').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix, */*;q=0.1', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Ruby RDF.rb/3.1.1' }).to_return(status: 500, body: '', headers: {})
        stub_request(:get, 'http://opaquenamespace.org/ns/creator/ChabreWayne').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix, */*;q=0.1', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Ruby RDF.rb/3.0.13' }).to_return(status: 500, body: '', headers: {})
      end

      it 'raises an exception' do
        expect { worker.perform(work.id, controlled_val, controlled_prop) }.to raise_error TriplestoreAdapter::TriplestoreException
      end
    end
  end
end
