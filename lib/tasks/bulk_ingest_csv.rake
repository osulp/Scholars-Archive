# frozen_string_literal:true

require 'csv'
STDOUT.sync = true

# GENERIC DESCRIPTION
namespace :scholars_archive do
  desc "Bulk ingest works based on a simple CSV"
  task bulk_ingest_csv: :environment do
    csv_file = ENV['csv']
    path = ENV['path']
    user = ENV['user']
    process_ingest_csv(csv_file, path, user)
  end
end

def process_ingest_csv(path, file_path, user)
  # Create logger
  datetime_today = Time.now.strftime('%Y%m%d%H%M%S') # "20171021125903"
  Rails.logger.info "Processing bulk ingest to works in csv: #{path}"

  csv = CSV.table(path, converters: nil)
  csv.each do |row|
    ingest_work(row, file_path, user)
  end
end

def ingest_work(row, file_path, user)
  # Get work type
  work_type = row['worktype'.to_sym].gsub(' ', '').constantize
  # Get collection
  collection = Collection.find(row['collection_id'.to_sym])
  # Generate work based on work type
  work = work_type.new

  u = User.find_by_username(user)

  # Set properties
  work = set_work_properties(work, row)
  work.date_uploaded = Hyrax::TimeService.time_in_utc
  work.depositor = u.username
  work.visibility = row[:visibility] unless row[:visibility].nil?
  work&.save

  # Set Workflow entity and deposited
  se = Sipity::Entity.new(proxy_for_global_id: work.to_global_id)
  se.workflow_id = 218
  se.workflow_state_id = 659
  se.save

  # Generates uploaded file for work and attaches said file to that work
  f = File.open("#{file_path}/#{ row[:filename] }")
  uploaded = Hyrax::UploadedFile.create(user_id: u.id, file: f)
  actor_env = Hyrax::Actors::Environment.new(work, u.ability, {"uploaded_files"=>[uploaded.id], 'visibility' => work.visibility})
  Hyrax::CurationConcern.actor.update(actor_env)

  # Adds the work to the collection
  collection.add_member_objects([work.id])
end

def set_work_properties(work, row)
  # Grab the class model for multiplicity checks
  nested_ordered_title_attributes = []
  nested_ordered_creator_attributes = []
  nested_ordered_abstract_attributes = []
  nested_ordered_contributor_attributes = []
  nested_ordered_additional_information_attributes = []
  nested_related_items = []

  # Iterate over csv row
  row.each do |property, value|
    next if skip_props.include? property

    # Check if field is an ordered field
    if ordered_properties.include? property.to_s.split('_').first
    # Grab field name and build attributes
      case property.to_s.split('_').first
      when 'title'
        nested_ordered_title_attributes << process_ordered_field(property, row[property]) unless row[property].nil?
      when 'creator'
        nested_ordered_creator_attributes << process_ordered_field(property, row[property]) unless row[property].nil?
      when 'abstract'
        nested_ordered_abstract_attributes << process_ordered_field(property, row[property]) unless row[property].nil?
      when 'contributor'
        nested_ordered_contributor_attributes << process_ordered_field(property, row[property]) unless row[property].nil?
      when 'additional_information'
        nested_ordered_additional_information_attributes << process_ordered_field(property, row[property]) unless row[property].nil?
      else
      end
    elsif nested_property_labels.include? property.to_s
      case property.to_s
      when 'nested_related_items_label'
        nested_related_items << { 'label' => value, 'related_url' => row[:nested_related_items_related_url] }
      end
    # Check multiplicity
    elsif Hyrax::FormMetadataService.multiple?(work.class, property) || property.to_s == "rights_statement"
      # If no value exists, set to array
      if work[property].empty?
        work[property] = [row[property]]
      # If value exists, add value to existing values
      else
        work[property] << row[property]
      end
    # Non Multiple field
    else
      work[property] = row[property]
    end
  end

  # Set nested ordered attributes
  work.nested_ordered_title_attributes = nested_ordered_title_attributes
  work.nested_ordered_creator_attributes = nested_ordered_creator_attributes
  work.nested_ordered_abstract_attributes = nested_ordered_abstract_attributes
  work.nested_ordered_contributor_attributes = nested_ordered_contributor_attributes
  work.nested_ordered_additional_information_attributes = nested_ordered_additional_information_attributes
  work.nested_related_items_attributes = nested_related_items
  work
end

def process_ordered_field(property, value)
  # Grab the property name
  if property.to_s.split('_').second.nil?
    return { index: 0, property.to_s.split('_').first => value }
  else
    return { index: property.to_s.split('_').second.to_i, property.to_s.split('_').first => value }
  end
end

def ordered_properties
  %w[title creator abstract contributor additional_information related_items]
end

def nested_property_labels
  %w[nested_related_items_label]
end

def nested_property_other_values
  %w[nested_related_items_related_url]
end

def skip_props
  %i[worktype filename link_to_file collection_id visibility] + nested_property_other_values.map(&:to_sym)
end
