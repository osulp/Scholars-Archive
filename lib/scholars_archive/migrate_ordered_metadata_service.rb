require 'csv'

module ScholarsArchive
  class MigrateOrderedMetadataService
    ##
    # Open and read CSVs into memory to prevent unnecessary IO for processing multiple works,
    # then provide methods for querying, ordering, and migrating a work based on CSV data and/or
    # the orginal data in the SOLR index
    def initialize(args)
      @creator_csv = CSV.read(args[:creator_csv_path])
      @title_csv = CSV.read(args[:title_csv_path])
      @logger = Logger.new(File.join(Rails.root, 'log', 'ordered-metadata-migration.log'))
    end

    ##
    # For the given handle, detect if the work has already been migrated or perform the migration
    def has_migrated?(handle: nil, work: nil)
      work_id = work.present? ? work.id : nil
      log("MigrateOrderedMetadataService(handle:#{handle}, work:#{work_id}) : Processing")
      doc = solr_doc(handle, work)
      if migrated?(doc)
        log("MigrateOrderedMetadataService(handle:#{handle}, work:#{work_id}) : #{doc['id']} : Work has already been migrated")
      else
        log("MigrateOrderedMetadataService(handle:#{handle}, work:#{work_id}) : #{doc['id']} : Finding work, attempting to migrate")
        work = fedora_work(doc['id']) unless work.present?
        work.nested_ordered_creator_attributes = creators(handle, doc)
        work.nested_ordered_title_attributes = titles(handle, doc)
        work.nested_related_items_attributes = related_items(doc)
        work.nested_contributor_attributes = contributors(doc)
        work.nested_description_attributes = descriptions(doc)
        work.nested_abstract_attributes = abstracts(doc)
        work.save
        log("MigrateOrderedMetadataService(handle:#{handle}, work:#{work_id}) : #{doc['id']} : Work successfully migrated")
      end
      true
    rescue StandardError => e
      trace = e.backtrace.join("\n")
      msg = "MigrateOrderedMetadataService(handle:#{handle}, work:#{work_id}) : Error migrating work; #{e.message}\n#{trace}"
      Rails.logger.error(msg)
      @logger.error(msg)
      false
    end

    private

    def log(msg)
      @logger.debug(msg)
      Rails.logger.debug(msg)
    end

    def creators(handle, solr_doc)
      ordered_metadata(@creator_csv, handle, solr_doc, 'creator_tesim', 'creator')
    end

    def titles(handle, solr_doc)
      ordered_metadata(@title_csv, handle, solr_doc, 'title_tesim', 'title')
    end

    def related_items(solr_doc)
      found = solr_doc['nested_related_items_label_ssim'] || []
      found.map.with_index { |obj, i| { index: i, label: obj.split('$').first, uri: obj.split('$').last } }
    end

    def contributors(solr_doc)
      ordered_solr_metadata(solr_doc, 'contributor_tesim')
    end

    def abstracts(solr_doc)
      ordered_solr_metadata(solr_doc, 'abstract_tesim')
    end

    def descriptions(solr_doc)
      ordered_solr_metadata(solr_doc, 'description_tesim')
    end

    def fedora_work(id)
      work = ActiveFedora::Base.find(id)
    end

    def solr_doc(handle, work)
      if handle.present?
        uri = RSolr.solr_escape("http://hdl.handle.net/#{handle}")
        ActiveFedora::SolrService.query("replaces_ssim:#{uri}").first
      else
        ActiveFedora::SolrService.query("id:#{work.id}").first
      end
    end

    ##
    # Work has the two common required ordered fields indexed
    def migrated?(solr_doc)
      solr_doc['nested_ordered_creator_tesim'].present? &&
        !solr_doc['nested_ordered_creator_tesim'].empty? &&
        solr_doc['nested_ordered_title_tesim'].present? &&
        !solr_doc['nested_ordered_title_tesim'].empty?
    end

    def ordered_solr_metadata(solr_doc, solr_field)
      found = solr_doc[solr_field] || []
      found.map.with_index { |obj, i| { index: i, label: obj } }
    end

    def ordered_metadata(csv, handle, solr_doc, solr_field, ordered_field_name)
      csv_metadata = ordered_csv_metadata(csv, handle, ordered_field_name)
      solr_metadata = solr_doc[solr_field]
      if csv_metadata.empty?
        combined = solr_metadata
      else
        combined = csv_metadata.concat(solr_metadata_not_in_csv(csv_metadata, solr_metadata))
      end
      combined.map.with_index { |obj, i| { index: i, ordered_field_name.to_sym => obj }}
    end

    def ordered_csv_metadata(csv, handle, ordered_field_name)
      return [] if handle.nil?
      # In the target CSV, find the rows that have a matching handle column,
      # then sort and map those rows in order.
      #
      # ie. [ 'Ross, Bob', 'Ross, Steve' ]
      csv.select { |l| l[4].casecmp(handle).zero? }
         .sort_by! { |obj| obj[3] }
         .map { |obj| obj[2] }
    end

    def solr_metadata_not_in_csv(csv_metadata, solr_metadata)a
      not_in_csv = solr_metadata.select { |s| !csv_metadata.include?(s) }
      log("ERROR: Found solr metadata that wasn't in the CSV, appending to the end of the list during migration => #{not_in_csv.join('; ')}") unless not_in_csv.empty?
      not_in_csv
    end
  end
end