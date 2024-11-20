# frozen_string_literal: true

# Sidekiq Worker for fetching linked data labels
class FetchFailedGraphWorker
  include Sidekiq::Worker
  sidekiq_options retry: 11

  def perform(pid, val, controlled_prop)
    work = ActiveFedora::Base.find(pid)
    solr_doc = work.to_solr

    if val.respond_to?(:fetch)
      val.fetch(headers: { 'Accept' => default_accept_header })
      val.persist!
    end

    if controlled_prop.to_s == 'based_near'
      solr_based_near_linked_insert(solr_doc, val)
    else
      solr_funding_body_linked_insert(solr_doc, val)
    end

    ActiveFedora::SolrService.add(solr_doc)
    ActiveFedora::SolrService.commit
  end

  def solr_based_near_linked_insert(solr_doc, val)
    solr_doc['based_near_linked_tesim'] = [val.solrize.last.is_a?(String) ? val.solrize.last : val.solrize.last[:label].split('$').first]
    solr_doc['based_near_linked_ssim'] = [val.solrize.last.is_a?(String) ? val.solrize.last : val.solrize.last[:label].split('$').first]
    solr_doc['based_near_linked_sim'] = [val.solrize.last.is_a?(String) ? val.solrize.last : val.solrize.last[:label].split('$').first]
  end

  def solr_funding_body_linked_insert(solr_doc, val)
    solr_doc['funding_body_linked_tesim'] = [val.solrize.last.is_a?(String) ? val.solrize.last : val.solrize.last[:label].split('$').first]
    solr_doc['funding_body_linked_ssim'] = [val.solrize.last.is_a?(String) ? val.solrize.last : val.solrize.last[:label].split('$').first]
    solr_doc['funding_body_linked_sim'] = [val.solrize.last.is_a?(String) ? val.solrize.last : val.solrize.last[:label].split('$').first]
  end

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
