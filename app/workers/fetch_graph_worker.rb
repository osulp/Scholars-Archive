# frozen_string_literal: true

# Sidekiq Worker for fetching linked data labels
class FetchGraphWorker
  include Sidekiq::Worker
  sidekiq_options retry: 11 # Around 2.5 days of retries

  # JOBS TEND TOWARD BEING LARGE. DISABLED BECAUSE FETCHING IS HEAVY HANDED.
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def perform(pid, _user_key)
    # Fetch Work and SolrDoc
    work = ActiveFedora::Base.find(pid)
    solr_doc = work.to_solr
    # TODO: ADD BACK IN WHEN SETTING UP EMAIL
    # user = User.where(email: user_key).first

    # Iterate over Controller Props values
    work.attributes['based_near'].each do |val|
      val = Hyrax::ControlledVocabularies::Location.new(val) if val.include? 'sws.geonames.org'
      # Fetch labels
      if val.respond_to?(:fetch)
        begin
          val.fetch(headers: { 'Accept' => default_accept_header })
        # Since ActiveTriples doesnt actually raise a specific error class, we cant so we need to ignore this
        # rubocop:disable Style/RescueStandardError
        rescue => e
          Rails.logger.info "Failed #{e}"
          fetch_failed_graph(pid, val, :based_near)
          next
        end
        # rubocop:enable Style/RescueStandardError
        val.persist!
      end

      # Insert into SolrDocument
      label_and_uri = extracted_label(val.solrize, onlylabel: false)
      label_only = extracted_label(val.solrize, onlylabel: true)

      # Add based_near_linked for location links
      Solrizer.insert_field(solr_doc, 'based_near_linked', [label_and_uri], :stored_searchable)
      Solrizer.insert_field(solr_doc, 'based_near_linked', [label_and_uri], :facetable)
      Solrizer.insert_field(solr_doc, 'based_near_linked', [label_and_uri], :symbol)

      # Add to based_near_label to enable search and facets
      Solrizer.insert_field(solr_doc, 'based_near_label', [label_only], :stored_searchable)
      Solrizer.insert_field(solr_doc, 'based_near_label', [label_only], :facetable)
    end
    # Commit Changes
    ActiveFedora::SolrService.add(solr_doc)
    ActiveFedora::SolrService.commit
  end

  def extracted_label(input, onlylabel: false)
    return input.last if input.last.is_a?(String)

    label_obj = input.last[:label]
    return label_obj.split('$').first if onlylabel

    label_obj
  end

  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  # TODO: WILL INTEGRATE THIS WHEN REDOING EMAILING FOR THESE JOBS
  # def fetch_failed_callback(user, val)
  #   Hyrax.config.callback.run(:ld_fetch_failure, user, val.rdf_subject.value)
  # end

  def fetch_failed_graph(pid, val, controlled_prop)
    FetchFailedGraphWorker.perform_async(pid, val, controlled_prop)
  end

  def default_accept_header
    RDF::Util::File::HttpAdapter.default_accept_header.sub(%r{, \*\/\*;q=0\.1\Z}, '')
  end
end
