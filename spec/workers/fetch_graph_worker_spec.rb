# frozen_string_literal: true

require 'rails_helper'
RSpec.describe FetchGraphWorker, type: :worker do
  let(:worker) { described_class.new }
  let(:uri) { 'http://my.queryuri.com' }
  let(:user) { User.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false) } }
  let(:model) { Default.create(title: ['foo'], based_near: [controlled_val], depositor: user.email) }
  let(:controlled_val) { Hyrax::ControlledVocabularies::Location.new('https://sws.geonames.org/5761960/') }
  let(:work) { model }

  describe '#perform' do
    context 'when the request works' do
      before do
        allow(controlled_val).to receive(:fetch).with(:anything).and_return({})
        allow_any_instance_of(Hyrax::ControlledVocabularies::Location).to receive(:solrize).and_return(['https://sws.geonames.org/5761960/', { label: 'Chabre, Wayne$https://sws.geonames.org/5761960/' }])
        stub_request(:get, 'http://ci-test:8080/bigdata/namespace/rw/sparql?GETSTMTS&includeInferred=false&s=%3Chttps://sws.geonames.org/5761960/%3E').with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection' => 'keep-alive', 'Host' => 'ci-test:8080', 'Keep-Alive' => '30', 'User-Agent' => 'Ruby' }).to_return(status: 200, body: '', headers: {})
        stub_request(:get, 'https://sws.geonames.org/5761960/').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix, */*;q=0.1', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Ruby RDF.rb/3.1.1' }).to_return(status: 200, body: '', headers: {})
        stub_request(:get, 'https://sws.geonames.org/5761960/').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix, */*;q=0.1', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Ruby RDF.rb/3.0.13' }).to_return(status: 200, body: '', headers: {})
        stub_request(:get, 'https://sws.geonames.org/5761960/').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'sws.geonames.org', 'User-Agent' => 'Ruby RDF.rb/3.0.13' }).to_return(status: 200, body: '', headers: {})
        stub_request(:get, 'https://sws.geonames.org/5761960/').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'sws.geonames.org', 'User-Agent' => 'Ruby RDF.rb/3.1.1' }).to_return(status: 200, body: '', headers: {})
        stub_request(:get, 'https://sws.geonames.org/5761960/').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'sws.geonames.org', 'User-Agent' => 'Ruby RDF.rb/3.1.8' }).to_return(status: 200, body: '', headers: {})
      end

      it 'fetches a work and indexes its linked data labels' do
        worker.perform(work.id, work.depositor)
        expect(SolrDocument.find(work.id)['based_near_linked_tesim'].first).to eq 'Chabre, Wayne$https://sws.geonames.org/5761960/'
      end

      it 'fetches a work and indexes its linked data label for search' do
        worker.perform(work.id, work.depositor)
        expect(SolrDocument.find(work.id)['based_near_label_tesim'].first).to eq 'Chabre, Wayne'
      end
    end

    context 'when the request fails' do
      before do
        allow(controlled_val).to receive(:fetch).with(:anything).and_return({})
        allow_any_instance_of(Hyrax::ControlledVocabularies::Location).to receive(:solrize).and_return(['https://sws.geonames.org/5761960/', { label: 'Chabre, Wayne$https://sws.geonames.org/5761960/' }])
        # TODO: ADD THIS BACK IN WHEN SETTING UP EMAILING FOR JOBS
        # allow(worker).to receive(:fetch_failed_callback).with(nil, controlled_val).and_return(true)
        stub_request(:get, 'https://sws.geonames.org/5761960/').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix, */*;q=0.1', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Ruby RDF.rb/3.1.1' }).to_return(status: 500, body: '', headers: {})
        stub_request(:get, 'https://sws.geonames.org/5761960/').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix, */*;q=0.1', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Ruby RDF.rb/3.0.13' }).to_return(status: 500, body: '', headers: {})
        stub_request(:get, 'https://sws.geonames.org/5761960/').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'sws.geonames.org', 'User-Agent' => 'Ruby RDF.rb/3.0.13' }).to_return(status: 500, body: '', headers: {})
        stub_request(:get, 'https://sws.geonames.org/5761960/').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'sws.geonames.org', 'User-Agent' => 'Ruby RDF.rb/3.1.1' }).to_return(status: 500, body: '', headers: {})
        stub_request(:get, 'https://sws.geonames.org/5761960/').with(headers: { 'Accept' => 'application/n-triples, text/plain;q=0.2, application/ld+json, application/x-ld+json, application/rdf+xml, text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, text/html;q=0.5, application/xhtml+xml;q=0.7, image/svg+xml;q=0.4, application/n-quads, text/x-nquads;q=0.2, application/rdf+json, text/n3, text/rdf+n3;q=0.2, application/rdf+n3;q=0.2, application/normalized+n-quads, application/x-normalized+n-quads, text/csv;q=0.4, text/tab-separated-values;q=0.4, application/csvm+json, application/trig, application/x-trig;q=0.2, application/trix', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'sws.geonames.org', 'User-Agent' => 'Ruby RDF.rb/3.1.8' }).to_return(status: 500, body: '', headers: {})
      end

      it 'calls #fetch_failed_graph to fire off new job' do
        expect(worker).to receive(:fetch_failed_graph).once
        worker.perform(work.id, work.depositor)
      end
    end
  end
end
