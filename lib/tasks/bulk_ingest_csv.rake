# frozen_string_literal:true

require 'csv'
STDOUT.sync = true

##
# Expects a CSV in the format of id,from,to,property to change the value of a property for a specific ID. The
# CSV needs to include the header row.
#
# Single value metadata WILL ALWAYS REPLACE existing metadata with the new value in the 'to' column, regardless
# of which valid value is in the 'from' column. For multi-value metadata, the CSV 'from' column requires some
# sort of operation or value to complete, see following details:
# -------------------------------------------------------------------------
# * = all/any value should be replaced with value in the 'to' column
# + = add value in the 'to' column to existing metadata values
# [String] = replace the existing metadata value with the value in the 'to' column
# --------------------------------------------------------------------------
#
# Execute like so: $bundle exec rails scholars_archive:bulk_update_csv csv=/full/path/to/spreadsheet.csv
#
# See below for example csv:
# -----------------------
# id,from,to,property
# n296x1347,http://rightsstatements.org/vocab/CNE/1.0/,http://rightsstatements.org/vocab/InC/1.0/,rights_statement
namespace :scholars_archive do
  desc "Bulk ingest works based on a simple CSV"
  task bulk_update_csv: :environment do
    csv_file = ENV['csv']
    process_csv(csv_file)
  end
end

def process_csv(path)
  # Create logger
  datetime_today = Time.now.strftime('%Y%m%d%H%M%S') # "20171021125903"
  logger = ActiveSupport::Logger.new("#{Rails.root}/log/bulk-ingest-csv-#{datetime_today}.log")
  logger.info "Processing bulk ingest to works in csv: #{path}"

  csv = CSV.table(path, converters: nil)
  csv.each do |row|
    ingest_work(logger, row)
  end
end

def ingest_work(logger, row)
  # Get work type
  work_type = row['worktype'].gsub(' ', '').constantize
  # Get collection
  collection = ActiveFedora::Base.find(row['collection id'])
  # Generate work based on work type
  work = work_type.new
  # Set properties
  work = set_work_properties(logger, work, row)
  work&.save
end

def set_work_properties(logger, work, row)
  # Grab the class model for multiplicity checks
  class_model = work.has_model.first.constantize
  nested_ordered_title_attributes = []
  nested_ordered_creator_attributes = []
  nested_ordered_abstract_attributes = []
  nested_ordered_contributor_attributes = []
  nested_ordered_additional_information_attributes = []

  # Iterate over csv row
  row.except('worktype', 'filename', 'link to file', 'collection id').each_pair do |property, value|
    # Check if field is an ordered field
    if ordered_properties.include? property.split(' ').first
      # Grab field name and build attributes
      case property.split(' ').first 
      when 'title'
        nested_ordered_title_attributes << process_ordered_field(propery, value) unless value.empty?
      when 'creator'
        nested_ordered_creator_attributes << process_ordered_field(propery, value) unless value.empty?
      when 'abstract'
        nested_ordered_abstract_attributes << process_ordered_field(propery, value) unless value.empty?
      when 'contributor'
        nested_ordered_contributor_attributes << process_ordered_field(propery, value) unless value.empty?
      when 'additional_information'
        nested_ordered_additional_information_attributes << process_ordered_field(propery, value) unless value.empty?
      else
      end
    # Check multiplicity
    elsif Hyrax::FormMetadataService.multiple?(c, row[property])
      # If no value exists, set to array
      if work[property].empty?
        work[property] = [value] 
      # If value exists, add value to existing values
      else
        work[property] << value 
      end
    # Non Multiple field
    else
      work[property] = value
    end
  end

  # Set nested ordered attributes
  work.nested_ordered_title_attributes = nested_ordered_title_attributes
  work.nested_ordered_creator_attributes = nested_ordered_creator_attributes
  work.nested_ordered_abstract_attributes = nested_ordered_abstract_attributes
  work.nested_ordered_contributor_attributes = nested_ordered_contributor_attributes
  work.nested_ordered_additional_information_attributes = nested_ordered_additional_information_attributes
end

def process_ordered_field(property, value)
  # Grab the property name
  if property.split(' ').second.nil?
    return { index: 0, property.split(' ').first.to_s => value }
  else
    return { index: property.split(' ').second.to_i, property.split(' ').first.to_s => value }
  end
end

def ordered_properties
  %w[title creator abstract contributor additional_information]
end
