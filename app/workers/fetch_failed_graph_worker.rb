# frozen_string_literal: true

# Sidekiq Worker for fetching linked data labels
class FetchFailedGraphWorker
  include Sidekiq::Worker
  sidekiq_options retry: 11

  def perform(pid, val, _controlled_prop)
    work = ActiveFedora::Base.find(pid)
    solr_doc = work.to_solr

    if val.respond_to?(:fetch)
      val.fetch(headers: { 'Accept' => default_accept_header })
      val.persist!
    end

    solr_based_near_linked_insert(solr_doc, val)

    ActiveFedora::SolrService.add(solr_doc)
    ActiveFedora::SolrService.commit
  end

  # rubocop:disable Metrics/AbcSize
  def solr_based_near_linked_insert(solr_doc, val)
    Solrizer.insert_field(solr_doc, 'based_near_linked', [val.solrize.last.is_a?(String) ? val.solrize.last : val.solrize.last[:label].split('$').first], :stored_searchable)
    Solrizer.insert_field(solr_doc, 'based_near_linked', [val.solrize.last.is_a?(String) ? val.solrize.last : val.solrize.last[:label].split('$').first], :facetable)
    Solrizer.insert_field(solr_doc, 'based_near_linked', [val.solrize.last.is_a?(String) ? val.solrize.last : val.solrize.last[:label].split('$').first], :symbol)
  end
  # rubocop:enable Metrics/AbcSize

  def default_accept_header
    RDF::Util::File::HttpAdapter.default_accept_header.sub(%r{, \*\/\*;q=0\.1\Z}, '')
  end

  def run_success_callback(user, val)
    Hyrax.config.callback.run(:ld_fetch_success, user, val.rdf_subject.value)
  end

  sidekiq_retries_exhausted do
    Hyrax.config.callback.run(:ld_fetch_exhaust, user, val.rdf_subject.value)
  end
end