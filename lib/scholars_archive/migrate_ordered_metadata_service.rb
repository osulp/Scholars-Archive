require 'csv'

class MigrateOrderedMetadataService
  ##
  # Open and read CSVs into memory to prevent unnecessary IO for processing multiple works,
  # then provide methods for querying, ordering, and migrating a work based on CSV data and/or
  # the orginal data in the SOLR index
  def initialize(args)
    @creator_csv = CSV.read(args[:creator_csv_path])
    @title_csv = CSV.read(args[:title_csv_path])
  end

  ##
  # For the given handle, detect if the work has already been migrated or perform the migration
  def migrated_work?(handle)
    doc = solr_doc(handle).first
    if migrated?(doc)
      Rails.logger.debug("MigrateOrderedMetadataService : #{doc['id']} : Work has already been migrated")
    else
      Rails.logger.debug("MigrateOrderedMetadataService : #{doc['id']} : Finding work, attempting to migrate")
      work = ActiveFedora::Base.find(doc['id'])
      work.nested_ordered_creator_attributes = creators(handle, doc)
      work.nested_ordered_title_attributes = titles(handle, doc)
      work.nested_related_items_attributes = related_items(doc)
      # work.save

      # TODO:
      Rails.logger.debug("MigrateOrderedMetadataService : #{doc['id']} : Work successfully migrated")
    end
    true
    work
  rescue StandardError => e
    trace = e.backtrace.join("\n")
    Rails.logger.error("MigrateOrderedMetadataService : #{doc['id']} : Error migrating work; #{e.message}\n#{trace}")
    false
  end

  private

  def creators(handle, solr_doc)
    ordered_metadata(@creator_csv, handle, solr_doc, 'creator_tesim', 'creator')
  end

  def titles(handle, solr_doc)
    ordered_metadata(@title_csv, handle, solr_doc, 'title_tesim', 'title')
  end

  def related_items(solr_doc)
    found = solr_doc[solr_field]
    found.map.with_index { |obj, i| { index: i, label: obj.split('$').first, uri: obj.split('$').last } }
  end

  def solr_doc(handle)
    uri = RSolr.solr_escape("http://hdl.handle.net/#{handle}")
    ActiveFedora::SolrService.query("replaces_ssim:#{uri}")
  end

  ##
  # Work has the two common required ordered fields indexed
  def migrated?(solr_doc)
    solr_doc['nested_ordered_creator_tesim'].present? &&
      !solr_doc['nested_ordered_creator_tesim'].empty? &&
      solr_doc['nested_ordered_title_tesim'].present? &&
      !solr_doc['nested_ordered_title_tesim'].empty?
  end

  def ordered_metadata(csv, handle, solr_doc, solr_field, ordered_field_name)
    # In the target CSV, find the rows that have a matching handle column,
    # then sort and map those rows to the ordered data structure. If there are
    # not rows found in the CSV, then revert to mapping the original SOLR index data
    # to the ordered data structure
    #
    # ie. [ { index: 0, creator: 'Ross, Bob' }, { index: 1, creator: 'Ross, Steve' }]
    # ie. [ { index: 0, title: 'A brief history of time' }, { index: 1, title: 'Meditations on the concept of pizza' }]
    found = csv.select { |l| l[4].casecmp(handle).zero? }
               .sort_by! { |obj| obj[3] }
               .map
               .with_index { |obj, i| { index: i, ordered_field_name.to_sym => obj[2] } }
    return found unless found.empty?
    ordered_solr_metadata(solr_doc, solr_field, ordered_field_name)
  end

  def ordered_solr_metadata(solr_doc, solr_field, ordered_field_name)
    found = solr_doc[solr_field]
    found.map.with_index { |obj, i| { index: i, ordered_field_name.to_sym => obj } }
  end
end
