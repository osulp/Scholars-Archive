require 'csv'
STDOUT.sync = true

##
# Expects a CSV in the format of id,from,to,property to change the value of a property for a specific ID. The
# CSV needs to include the header row.
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
  datetime_today = DateTime.now.strftime('%Y%m%d%H%M%S') # "20171021125903"
  logger = ActiveSupport::Logger.new("#{Rails.root}/log/bulk-update-csv-#{datetime_today}.log")
  logger.info "Processing bulk update to works in csv: #{path}"

  csv = CSV.table(path)
  csv.each do |row|
    update_work(logger, row)
  end
end

def update_work(logger, row)
  work = ActiveFedora::Base.find(row[:id].to_s.gsub("'",""))
  work = update_property(logger, work, row)
  if(!work.nil?)
    work.save!(validate: false)
    work.update_index
  end
end

def update_property(logger, work, row)
  property = work[row[:property]]
  if(property.is_a?(String))
    work[row[:property]] = row[:to]
    logger.info("#{work.class} #{row[:id]} #{row[:property]} changed from \"#{row[:from]}\" to \"#{row[:to]}\"")
  elsif(property.is_a?(ActiveTriples::Relation))
    found_row = property.find{|r| r.include?(row[:from] || '')}
    if(found_row)
      work[row[:property]].delete(found_row)
      work[row[:property]] += [row[:to]]
      logger.info("#{work.class} #{row[:id]} #{property.property} changed from \"#{found_row}\" to \"#{row[:to]}\"")
    elsif(row[:from].casecmp('*').zero?)
      work[row[:property]] = [row[:to]]
      logger.info("#{work.class} #{row[:id]} #{property.property} row overwritten with \"#{row[:to]}\"")
    elsif(row[:from].blank?)
      work[row[:property]] += [row[:to]]
      logger.info("#{work.class} #{row[:id]} #{property.property} row added \"#{row[:to]}\"")
    else
      logger.info("#{work.class} #{row[:id]} #{property.property} value \"#{row[:from]}\" not found, skipping update.")
      return nil
    end
  else
    work[row[:property]] = row[:to]
    logger.info("#{work.class} #{row[:id]} #{row[:property]} set to \"#{row[:to]}\"")
  end
  return work
end
