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
  work = ActiveFedora::Base.find(row[:id].to_s.delete("'"))
  work = update_property(logger, work, row)
  work&.save
end

def update_property(logger, work, row)
  property = work[row[:property]]

  if row[:from].blank?
    logger.error("#{work.class} #{row[:id]} #{property.property} missing 'from' value in CSV, unable to process work.")
    return nil
  end

  if property.is_a?(String) || is_property_multiple?(work, row) == false
    work[row[:property]] = row[:to]&.to_s
    logger.info("#{work.class} #{row[:id]} #{row[:property]} changed from \"#{row[:from]}\" to \"#{row[:to]}\"")
  elsif property.is_a?(ActiveTriples::Relation)
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
  class_model = work.has_model.first.constantize
  Hyrax::FormMetadataService.multiple?(class_model,row[:property])
end

def overwrite_multivalue_row(logger, work, row, property)
  to_value = row[:to]&.to_s
  work[row[:property]] = [to_value&.split('|')].flatten
  logger.info("#{work.class} #{row[:id]} #{property.property} row overwritten with \"#{to_value}\"")
  work
end

def add_to_multivalue_row(logger, work, row, property)
  to_value = row[:to]&.to_s
  work[row[:property]] += [to_value&.split('|')].flatten
  logger.info("#{work.class} #{row[:id]} #{property.property} row added \"#{to_value}\"")
  work
end

def remove_from_multivalue_row(logger, work, row, property)
  to_value = row[:to]&.to_s
  work[row[:property]] = work[row[:property]].to_a - [to_value&.split('|')].flatten
  logger.info("#{work.class} #{row[:id]} #{property.property} row removed \"#{to_value}\"")
  work
end

def process_if_found_row(logger, work, row, property)
  found_row = property.find { |r| r.include?(row[:from]) }
  if found_row
    work[row[:property]] = nil if work[row[:property]].length == 1
    work[row[:property]].delete(found_row) if work[row[:property]].length > 1
    work[row[:property]] += [row[:to].to_s.split('|')].flatten unless row[:to].blank?
    logger.info("#{work.class} #{row[:id]} #{property.property} changed from \"#{found_row}\" to \"#{work[row[:property]]}\"")
    work
  else
    logger.info("#{work.class} #{row[:id]} #{property.property} value \"#{row[:from]}\" not found, skipping update.")
    nil
  end
end
