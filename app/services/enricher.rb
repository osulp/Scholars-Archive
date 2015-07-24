# Responsible for enriching a solr document and atomically updating the
# document.
class Enricher
  pattr_initialize(:id)

  # Perform enrichment
  def enrich!
    unless enriched_solr_document.empty?
      perform_atomic_update!
    end
  end

  private

  def perform_atomic_update!
    connection.update(
      :params => { softCommit: true },
      :data => solr_json,
      :headers => { 'Content-Type' => 'application/json' }
    )
  end

  def solr_json
    [enriched_solr_document].to_json
  end

  def enriched_solr_document
    @enriched_solr_document ||= EnrichedSolrDocument.new(solr_document).to_solr
  end

  def solr_document
    @solr_document ||= solr_service.query("id:#{RSolr.solr_escape(id)}").first
  end

  def connection
    @connection ||= ActiveFedora.solr.conn
  end

  def solr_service
    @solr_service ||= ActiveFedora::SolrService
  end
end
