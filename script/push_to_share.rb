#!/usr/bin/env ruby

# This code is adapted from University Notre Dame Library's Curate Repository
# https://github.com/ndlib/curate_nd
# 
# Push the data in a CSV file to the SHARE push gateway.
# Parameters can be configured using environment variables.
#
# Sample usage is
#
#     env SHARE_HOST=https://share.osf.io SHARE_TOKEN=1234567890 ./push-to-share.rb data-file.csv
#

require 'csv'
require 'share_notify'

if ARGV.length < 1
  puts <<-EOS
usage: push-to-share.rb <list of csv files>

Push the records in all the csv files to the SHARE Push Gateway.
Status messages are printed to STDOUT.

Configure using the SHARE_HOST and SHARE_TOKEN environment variables.
EOS

  exit 2
end

share_host = ENV["SHARE_HOST"] || "https://staging-share-registration.osf.io"
share_token = ENV["SHARE_TOKEN"]

puts "Using SHARE_HOST=#{share_host}"
puts "Using SHARE_TOKEN=#{share_token}"

ShareNotify.configure "host" => share_host, "token" => share_token
api = ShareNotify::API.new

overall_record_count = 0
error_count = 0
ARGV.each do |csv_filename|
  puts "Reading #{csv_filename}"
  file_record_count = 0
  first_line = true
  columns = {} # mapping from column name -> column index for this csv file
  CSV.foreach(csv_filename) do |row|
    if first_line
      # first row is the column labels
      row.each_with_index do |label, index|
        columns[label] = index
      end
      first_line = false
      next
    end
    overall_record_count += 1
    file_record_count += 1

    id = row[columns["id"]]
    modified = row[columns["system_modified_dtsi"]]
    title = row[columns["desc_metadata__title_tesim"]]
    contributors = row[columns["desc_metadata__creator_tesim"]]
    contributors = (contributors || "").split("|")

    puts "#{overall_record_count} / #{file_record_count} Pushing #{id}"
    document = ShareNotify::PushDocument.new(id, modified)
    document.title = title
    contributors.each do |name|
      document.add_contributor(name: name)
    end

    unless document.valid?
      puts @document.inspect
      puts "Document is invalid"
      error_count += 1
      next
    end

    response = api.post(document.to_share.to_json)
    if response.code != 202
      puts "Received code #{response.code}"
      puts response.body
      exit 1
    end
  end
end

puts "Finished. #{overall_record_count} records, #{error_count} errors"
