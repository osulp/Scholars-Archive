# frozen_string_literal: true

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
      @contributor_csv = CSV.read(args[:contributor_csv_path])
      @logger = Logger.new(File.join(Rails.root, 'log', 'ordered-metadata-migration.log'))
    end

    ##
    # For the given handle, detect if the work has already been migrated or perform the migration
    def has_migrated?(handle: nil, work: nil, force_update: false)
      work_id = work.present? ? work.id : nil
      log("MigrateOrderedMetadataService(handle:#{handle}, work:#{work_id}) : Processing")
      doc = solr_doc(handle, work)
      if migrated?(doc) && !force_update
        log("MigrateOrderedMetadataService(handle:#{handle}, work:#{work_id}) : #{doc['id']} : Work has already been migrated")
      else
        creators = creators(handle, doc)
        titles = titles(handle, doc)
        related_items = related_items(doc)
        contributors = contributors(handle, doc)
        additional_informations = additional_informations(doc)
        abstracts = abstracts(doc)

        log("MigrateOrderedMetadataService(handle:#{handle}, work:#{work_id}) : #{doc['id']} : Finding work, attempting to migrate")
        work = fedora_work(doc['id']) unless work.present?
        work.nested_ordered_creator_attributes = creators unless creators.empty?
        work.nested_ordered_title_attributes = titles unless titles.empty?
        work.nested_related_items_attributes = related_items unless related_items.empty?
        work.nested_contributor_attributes = contributors unless contributors.empty?
        work.nested_additional_information_attributes = additional_informations unless additional_informations.empty?
        work.nested_abstract_attributes = abstracts unless abstracts.empty?
        work.save
        log("MigrateOrderedMetadataService(handle:#{handle}, work:#{work_id}) : #{doc['id']} : Work successfully migrated")

        work.members.reject { |m| m.class == 'FileSet' }.each do |child|
          log("MigrateOrderedMetadataService(handle:#{handle}, work:#{work_id}) : child_work:#{child.id} : Finding child work, attempting to migrate")
          child.nested_ordered_creator_attributes = creators unless creators.empty?
          child.nested_ordered_title_attributes = ordered_solr_metadata({ 'title_tesim' => child.title }, 'title_tesim', 'title')
          child.nested_related_items_attributes = related_items unless related_items.empty?
          child.nested_contributor_attributes = contributors unless contributors.empty?
          child.nested_additional_information_attributes = additional_informations unless additional_informations.empty?
          child.nested_abstract_attributes = abstracts unless abstracts.empty?
          child.save
          log("MigrateOrderedMetadataService(handle:#{handle}, work:#{work_id}) : child_work:#{child.id} : Work successfully migrated")
        end
      end
      true
    rescue StandardError => e
      trace = e.backtrace.join("\n")
      msg = "MigrateOrderedMetadataService(handle:#{handle}, work:#{work_id}) : Error migrating work; #{e.message}\n#{trace}"
      Rails.logger.error(msg)
      @logger.error(msg)
      false
    end

    # private

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
      found.map.with_index { |obj, i| { index: i, label: obj.split('$').first, related_url: obj.split('$').last } }
    end

    def contributors(handle, solr_doc)
      ordered_metadata(@contributor_csv, handle, solr_doc, 'contributor_tesim', 'contributor')
    end

    def abstracts(solr_doc)
      ordered_solr_metadata(solr_doc, 'abstract_tesim', 'abstract')
    end

    def additional_informations(solr_doc)
      ordered_solr_metadata(solr_doc, 'additional_information_tesim', 'additional_information')
    end

    def fedora_work(id)
      ActiveFedora::Base.find(id)
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

    def ordered_solr_metadata(solr_doc, solr_field, ordered_field_name)
      found = solr_doc[solr_field] || []
      found.map.with_index { |obj, i| { index: i, ordered_field_name.to_sym => obj } }
    end

    def ordered_metadata(csv, handle, solr_doc, solr_field, ordered_field_name)
      csv_metadata = ordered_csv_metadata(csv, handle)
      solr_metadata = solr_doc[solr_field] || []
      if csv_metadata.empty?
        combined = solr_metadata
      else
        combined = csv_metadata.concat(solr_metadata_not_in_csv(csv_metadata, solr_metadata))
      end
      combined.map.with_index { |obj, i| { index: i, ordered_field_name.to_sym => obj } }
    end

    def ordered_csv_metadata(csv, handle)
      return [] if handle.nil?
      # In the target CSV, find the rows that have a matching handle column,
      # then sort and map those rows in order.
      #
      # ie. [ 'Ross, Bob', 'Ross, Steve' ]
      csv.select { |l| l[4].casecmp(handle).zero? }
         .sort_by! { |obj| obj[3] }
         .map { |obj| obj[2] }
    end

    def solr_metadata_not_in_csv(csv_metadata, solr_metadata)
      not_in_csv = solr_metadata.reject { |s| csv_metadata.include?(s) }
      log("ERROR: Found solr metadata that wasn't in the CSV, appending to the end of the list during migration => #{not_in_csv.join('; ')}") unless not_in_csv.empty?
      not_in_csv
    end
  end
end
