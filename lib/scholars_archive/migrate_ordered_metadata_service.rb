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

  def migrated?
    # TODO: Inspect if the item is already migrated
    true
  end

  ##
  # For the given handle, detect if the work has already been migrated or perform the migration
  def migrated_work?(handle)
    doc = solr_doc(handle)
    work = ActiveFedora::Base.find(doc.first['id'])
    # TODO: Log if migrated work already?
    return if migrated?(work)
    # TODO:
    # - creators(handle, doc)
    # - titles(handle, doc)
    # - update the work nested_ordered_* fields
    # - log that the work was migrated
    # - return true
  rescue StandardError => e
    # TODO: log the error
  end

  def solr_doc(handle)
    uri = RSolr.solr_escape("http://hdl.handle.net/#{handle}")
    ActiveFedora::SolrService.query("replaces_ssim:#{uri}")
  end

  def creators(handle, solr_doc)
    ordered_metadata(@creator_csv, handle, solr_doc, 'creator_tesim', 'creator')
  end

  def titles(handle, solr_doc)
    ordered_metadata(@title_csv, handle, solr_doc, 'title_tesim', 'title')
  end

  private

  def ordered_metadata(csv, handle, solr_doc, solr_field, ordered_field_name)
    # In the target CSV, find the rows that have a matching handle column,
    # then sort and map those rows to the ordered data structure. If there are
    # now rows found in the CSV, then revert to mapping the original SOLR index data
    # to the ordered data structure
    #
    # ie. [ { index: 0, creator: 'Ross, Bob' }, { index: 1, creator: 'Ross, Steve' }]
    # ie. [ { index: 0, title: 'A brief history of time' }, { index: 1, title: 'Meditations on the concept of pizza' }]
    found = csv.select { |l| l[4].casecmp(handle).zero? }
               .sort_by! { |obj| obj[3] }
               .map
               .with_index { |obj, i| { index: i, ordered_field_name.to_sym => obj[2] } }
    return found unless found.empty?

    found = solr_doc.first[solr_field]
    found.map.with_index { |obj, i| { index: i, ordered_field_name.to_sym => obj } }
  end
end
