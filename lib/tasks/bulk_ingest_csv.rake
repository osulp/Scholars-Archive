# frozen_string_literal:true

require 'csv'
STDOUT.sync = true

# GENERIC DESCRIPTION
namespace :scholars_archive do
  desc "Bulk ingest works based on a simple CSV"
  task bulk_ingest_csv: :environment do
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

  # Generates uploaded file for work and attaches said file to that work
  f = File.open("/data/tmp/bulk-ingest/#{row['filename']}")
  u = User.first
  uploaded = Hyrax::UploadedFile.create(user: u, file_set_uri: "file:///data/tmp/bulk-ingest/#{row['filename']}", file: f)
  actor_env = Hyrax::Actors::Environment.new(work, u.ability, {"uploaded_files"=>[uploaded.id]})
  Hyrax::CurationConcern.actor.update(actor_env)

  # Adds the work to the collection
  collection.add_member_objects([work.id])
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
