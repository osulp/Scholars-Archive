# frozen_string_literal: true

# Sidekiq Worker for fetching linked data labels
class FetchGraphWorker
  include Sidekiq::Worker
  sidekiq_options retry: 11

  def perform(pid, _user_key)
    work = ActiveFedora::Base.find(pid)
    solr_doc = work.to_solr

    work.attributes['based_near'].each do |val|
      val = Hyrax::ControlledVocabularies::Location.new(val) if val.include? 'sws.geonames.org'

      next if fetch_and_persist(val, pid) == false

      solr_based_near_label_insert(solr_doc, val)
      solr_based_near_linked_insert(solr_doc, val)
    end
    ActiveFedora::SolrService.add(solr_doc)
    ActiveFedora::SolrService.commit
  end

  def fetch_and_persist(val, pid)
    begin
      val.fetch(headers: { 'Accept' => default_accept_header }) if val.respond_to?(:fetch)
    # rubocop:disable Style/RescueStandardError
    rescue => e
      Rails.logger.info "Failed #{e}"
      fetch_failed_graph(pid, val, :based_near)
      return false
    end
    # rubocop:enable Style/RescueStandardError
    val.persist!
  end

  def solr_based_near_linked_insert(solr_doc, val)
    solr_doc['based_near_linked_tesim'] = [extracted_label(val.solrize, onlylabel: false)]
    solr_doc['based_near_linked_ssim'] = [extracted_label(val.solrize, onlylabel: false)]
    solr_doc['based_near_linked_sim'] = [extracted_label(val.solrize, onlylabel: false)]
  end

  def solr_based_near_label_insert(solr_doc, val)
    solr_doc = ['based_near_label_tesim']
    solr_doc = ['based_near_label_sim']
  end

  def extracted_label(input, onlylabel: false)
    return input.last if input.last.is_a?(String)

    label_obj = input.last[:label]
    return label_obj.split('$').first if onlylabel

    label_obj
  end

  def fetch_failed_graph(pid, val, controlled_prop)
    FetchFailedGraphWorker.perform_async(pid, val, controlled_prop)
  end

  def default_accept_header
    RDF::Util::File::HttpAdapter.default_accept_header.sub(%r{, \*\/\*;q=0\.1\Z}, '')
  end
end
