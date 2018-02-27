require 'csv'
STDOUT.sync = true

namespace :scholars_archive do
  desc "Bulk update works based on a simple CSV with id, 'from property value', 'to property value'"
  task bulk_update_csv: :environment do
    csv_file = ENV['csv']
    process_csv(csv_file)
  end
end

def get_csv_rows(path)
end

def process_csv(path)
  # Create logger
  datetime_today = DateTime.now.strftime('%Y%m%d%H%M%S') # "20171021125903"
  logger = ActiveSupport::Logger.new("#{Rails.root}/log/bulk-update-csv-#{datetime_today}.log")
  logger.info "Processing bulk update to works in csv: #{path}"
  counter = 0

  csv = CSV.table(path)

end
