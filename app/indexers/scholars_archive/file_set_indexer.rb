# frozen_string_literal: true

module ScholarsArchive
  # CLASS: Indexer that indexes fileset specific metadata
  class FileSetIndexer < Hyrax::FileSetIndexer
    # ADD: Inherit from Hyrax and add in special solr
    def generate_solr_document
      super.tap do |solr_doc|
        # ADD: Solrize the :ext_relation
        solr_doc['ext_relation_sim'] = object.ext_relation
        solr_doc['ext_relation_ssim'] = object.ext_relation
        solr_doc['ext_relation_tesim'] = object.ext_relation

        # ADD: Solrize the :oembed_url
        solr_doc['oembed_url_sim'] = object.oembed_url
        solr_doc['oembed_url_ssim'] = object.oembed_url
        solr_doc['oembed_url_tesim'] = object.oembed_url
      end
    end
  end
end
