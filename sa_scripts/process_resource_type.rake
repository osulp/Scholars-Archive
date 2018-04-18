require 'csv'
STDOUT.sync = true

namespace :scholars_archive do
  desc "Resource Type Processing"
  task process_resource_type: :environment do
    resource_type_csv = ENV['resource_type_csv']
    process_resource_type(resource_type_csv)
  end
end

def process_resource_type(resource_type_csv)
  csv_file = File.join(File.dirname(__FILE__), resource_type_csv)
  lines = CSV.read(csv_file, headers: true, encoding: 'ISO-8859-1:UTF-8').map(&:to_hash)
  lines.each do |line|
    begin
      work_id = line['id']
      puts "Processing #{work_id}"
      work = ActiveFedora::Base.find(work_id)
      resource_type = line['resource_type_tesim']
      work.resource_type = [resource_type]
      work.save!
    rescue => e
      puts "ERROR processing #{work_id} :#{e}"
    end
  end
end