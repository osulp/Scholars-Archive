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
  desc "Bulk update works based on a simple CSV with id, 'from property value', 'to property value'"
  task bulk_update_csv: :environment do
    csv_file = ENV['csv']
    process_csv(csv_file)
  end
end

def process_csv(path)
  # Create logger
  datetime_today = Time.now.strftime('%Y%m%d%H%M%S') # "20171021125903"
  logger = ActiveSupport::Logger.new("#{Rails.root}/log/bulk-update-csv-#{datetime_today}.log")
  logger.info "Processing bulk update to works in csv: #{path}"

  csv = CSV.table(path, converters: nil)
  csv.each do |row|
    update_work(logger, row)
  end
end

def update_work(logger, row)
  begin
    work = ActiveFedora::Base.find(row[:id].to_s.delete("'"))
    work = update_property(logger, work, row)
    work&.save
  rescue StandardError => e
    logger.error "Error saving: #{row[:id]} : #{e.backtrace}"
    return nil
  end
end

def update_property(logger, work, row)
  property = work[row[:property]]

  if row[:from].blank?
    logger.error("#{work.class} #{row[:id]} #{row[:property]} missing 'from' value in CSV, unable to process work.")
    return nil
  end

  if property.is_a?(String) || is_property_multiple?(work, row) == false
    work[row[:property]] = row[:to]&.to_s
    logger.info("#{work.class} #{row[:id]} #{row[:property]} changed from \"#{row[:from]}\" to \"#{row[:to]}\"")
  elsif property.is_a?(ActiveTriples::Relation) || ordered_property?(row[:property])
    work = if row[:from].casecmp('+').zero?
             add_to_multivalue_row(logger, work, row, property)
           elsif row[:from].casecmp('*').zero?
             overwrite_multivalue_row(logger, work, row, property)
           elsif row[:from].casecmp('-').zero?
             remove_from_multivalue_row(logger, work, row, property)
           else
             process_if_found_row(logger, work, row, property)
           end
  else
    work[row[:property]] = [row[:to].to_s.split('|')].flatten
    logger.info("#{work.class} #{row[:id]} #{row[:property]} set to \"#{row[:to]}\"")
  end
  work
end

def is_property_multiple?(work, row)
  # rights_statement is stored in a multi-valued field even though it's considered a single value.
  return true if row[:property] == 'rights_statement'
  class_model = work.has_model.first.constantize
  Hyrax::FormMetadataService.multiple?(class_model,row[:property])
end

def overwrite_multivalue_row(logger, work, row, property)
  to_value = row[:to]&.to_s
  
  if ordered_property? row[:property] && to_value.present?
    handle_ordered_property(work, 'overwrite_ordered_property_value', to_value, row)
  else
    work[row[:property]] = to_value.blank? ? nil : [to_value&.split('|')].flatten
  end
  logger.info("#{work.class} #{row[:id]} #{row[:property]} row overwritten with \"#{to_value}\"")
  work
end

def add_to_multivalue_row(logger, work, row, property)
  to_value = row[:to]&.to_s
  return work if to_value.blank?

  if ordered_property? row[:property]
    handle_ordered_property(work, 'add_ordered_property_value', to_value, row)
  else
    work[row[:property]] += [to_value&.split('|')].flatten
  end
  logger.info("#{work.class} #{row[:id]} #{row[:property]} row added \"#{to_value}\"")
  work
end

def remove_from_multivalue_row(logger, work, row, property)
  to_value = row[:to]&.to_s
  return work if to_value.blank?

  if ordered_property? row[:property]
    handle_ordered_property(work, 'remove_ordered_property_value', to_value, row)
  else
    work[row[:property]] = work[row[:property]].to_a - [to_value&.split('|')].flatten
  end
  logger.info("#{work.class} #{row[:id]} #{row[:property]} row removed \"#{to_value}\"")
  work
end

def process_if_found_row(logger, work, row, property)
  found_row = property.find { |r| r.include?(row[:from]) }
  if found_row
    work[row[:property]] = nil if work[row[:property]].length == 1
    work[row[:property]].delete(found_row) if work[row[:property]].length > 1
    work[row[:property]] += [row[:to].to_s.split('|')].flatten unless row[:to].blank?
    logger.info("#{work.class} #{row[:id]} #{row[:property]} changed from \"#{found_row}\" to \"#{work[row[:property]]}\"")
    work
  else
    logger.info("#{work.class} #{row[:id]} #{row[:property]} value \"#{row[:from]}\" not found, skipping update.")
    nil
  end
end

def handle_ordered_property(work, method, value, row)
  case row[:property]
  when 'title'
    original_values = work.send(:ordered_titles)
    work.nested_ordered_title = nil
    work.nested_ordered_title_attributes = self.method(method).call(original_values, 'title', value)
  when 'creator'
    original_values = work.send(:ordered_creators)
    work.nested_ordered_creator = nil
    work.nested_ordered_creator_attributes = self.method(method).call(original_values, 'creator', value)
  when 'abstract'
    original_values = work.send(:ordered_abstracts)
    work.nested_ordered_abstract = nil
    work.nested_ordered_abstract_attributes = self.method(method).call(original_values, 'abstract', value)
  when 'contributor'
    original_values = work.send(:ordered_contributors)
    work.nested_ordered_contributor = nil
    work.nested_ordered_contributor_attributes = self.method(method).call(original_values, 'contributor', value)
  when 'additional_information'
    original_values = work.send(:ordered_info)
    work.nested_ordered_additional_information = nil
    work.nested_ordered_additional_information_attributes = self.method(method).call(original_values, 'additional_information', value)
  else
    logger.error("#{work.class} #{row[:id]} #{row[:property]} unable to handle this type of ordered_*, rake task requires work to process these updates.")
  end
end

## Add new value(s) to properly shaped data for an ordered property
# @param [Array<String>] original_values : The original metadata values in the field
# @param [String] value_field : The ordered properties value field to be paired with its ordered 'index'
# @param [String] new_value : The new value(s), can be pipe-delimited to add to the end of the ordered metadata
# @return [Array<Hash<String,String>>] an array of {"index":, "#{value_field}":} shaped data
#         example: [{ "index": "0", "title": "title 1"}, { "index": "1", "title": "title 2"}]
def add_ordered_property_value(original_values, value_field, new_value)
  indexed_values = original_values.map.with_index { |v,i| { "index" => i, value_field.to_s => v } }
  new_value.split('|').each do |v|
    indexed_values << { "index" => indexed_values.last['index'] + 1, value_field.to_s => v }
  end
  indexed_values.map { |v| { "index" => v['index'].to_s, value_field.to_s => v[value_field] } }
end

## Remove an existing value from an ordered property
# @param [Array<String>] original_values : The original metadata values in the field
# @param [String] value_field : The ordered properties value field to be paired with its ordered 'index'
# @param [String] value : The value to be removed from the ordered metadata
# @return [Array<Hash<String,String>>] an array of {"index":, "#{value_field}":} shaped data
#         example: [{ "index": "0", "title": "title 1"}]
def remove_ordered_property_value(original_values, value_field, value)
  original_values.reject { |v| v == value}.map.with_index { |v,i| { "index" => i.to_s, value_field.to_s => v } }
end

## Overwrite all existing values to properly shaped data for an ordered property
# @param [Array<String>] original_values : The original metadata values in the field
# @param [String] value_field : The ordered properties value field to be paired with its ordered 'index'
# @param [String] new_value : The new value(s) to replace all existing ordered metadata, can be pipe-delimited to add to the end of the ordered metadata
# @return [Array<Hash<String,String>>] an array of {"index":, "#{value_field}":} shaped data
#         example: [{ "index": "0", "title": "title 1"}, { "index": "1", "title": "title 2"}]
def overwrite_ordered_property_value(original_values, value_field, new_value)
  new_value.split('|').map.with_index { |v,i| { "index" => i.to_s, value_field.to_s => v } }
end

## Is this one of the properties that are nested ordered metadata in the application
def ordered_property?(property_name)
  %w[title creator abstract contributor additional_information].include? property_name
end
