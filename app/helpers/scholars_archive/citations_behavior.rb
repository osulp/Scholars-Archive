# frozen_string_literal: true

module ScholarsArchive
  # Used to export citations
  module CitationsBehavior
    def export_as_apa_citation(work)
      ScholarsArchive::CitationsBehaviors::Formatters::ApaFormatter.new(self).format(work)
    end

    def export_as_chicago_citation(work)
      ScholarsArchive::CitationsBehaviors::Formatters::ChicagoFormatter.new(self).format(work)
    end

    def export_as_mla_citation(work)
      ScholarsArchive::CitationsBehaviors::Formatters::MlaFormatter.new(self).format(work)
    end

    # MIME type: 'application/x-openurl-ctx-kev'
    def export_as_openurl_ctx_kev(work)
      Hyrax::CitationsBehaviors::Formatters::OpenUrlFormatter.new(self).format(work)
    end
  end
end
