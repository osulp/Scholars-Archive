require 'csv'
STDOUT.sync = true

namespace :scholars_archive do
  desc "Process legacy stats file"
  task process_legacy_stats: :environment do
    stats_dir = ENV['stats_dir']
    bitstream_filename_csv = ENV['bitstream_filename_csv']
    process(stats_dir, bitstream_filename_csv)
  end
end

def process(stats_dir, bitstream_filename_csv)
  csv_output_path = File.join(Rails.root, 'tmp', 'legacy-stats-processed.csv')
  CSV.open(csv_output_path, 'ab') do |csv|
    user = User.first
    Dir.entries(stats_dir).each do |handle|
      begin
        puts "Processing #{File.join(stats_dir, handle)}"
        rows = get_csv_rows(stats_dir, handle)
        # move processing rows here, instead of in record processing, to speedup process
        filename_rows = add_filename_to_rows(rows, bitstream_filename_csv)
        work = find_parent_work(handle)
        #set_work_view_stats(work, filename_rows, user, csv)
        set_file_download_stats(work, filename_rows, user, csv)
      rescue => e
        puts "ERROR processing #{File.join(stats_dir, handle)} : #{e}"
      end
    end
  end
end

def get_csv_rows(stats_dir, handle)
  path = File.join(stats_dir, handle, "#{handle}.csv")
  CSV.read(path)
end

def find_parent_work(handle)
  # SOLR query for "replaces_ssim:http://hdl.handle.net/#{handle.gsub('-','/')}"
  handle = handle.gsub('-','/')
  uri = RSolr.solr_escape("http://hdl.handle.net/#{handle}")
  query_string = "replaces_ssim:#{uri}"
  solr = ActiveFedora::SolrService.query(query_string)
  solr.first
end

def find_fileset(work, file_name)
  solr = ActiveFedora::SolrService.query("id:(#{work['file_set_ids_ssim'].join(' ')})")
  solr.select { |s| stripped_filename(s['label_tesim'].first).casecmp(stripped_filename(file_name)) == 0 }
end

def stripped_filename(s)
  s.gsub(' ','').gsub('_','')
end

def set_work_view_stats(work, rows, user, csv)
  records = get_records(rows, "item")
  grouped = group_by_date(records, 2)
  grouped.each_pair do |k,v|
    csv << [DateTime.now, 'page_view', k, v.count, work.id, work.id, user.id]
    WorkViewStat.create(date: DateTime.parse(k), work_views: v.count, work_id: work.id, user_id: user.id )
  end
end

def set_file_download_stats(work, rows, user, csv)
  records = get_records(rows, "bitstream")
  file_groups = group_by_file(records, 1)
  file_groups.each_pair do |file_name, file_records|
    file = find_fileset(work, file_name)
    # error(file_name, file_records, work) if file.nil?
    next if file.nil?
    file_id = file.first['id']
    grouped = group_by_date(file_records, 2)
    grouped.each_pair do |k,v|
      csv << [DateTime.now, 'download', k, v.count, work.id, file_id, user.id]
      FileDownloadStat.create(date: DateTime.parse(k), downloads: v.count, file_id: file_id, user_id: user.id )
    end
  end
end

def get_records(rows, type)
  rows.select { |r| r[0].casecmp(type) == 0 }.map { |r| [r[0], r[5], r[20]] }
end

def group_by_date(rows, column)
  rows.group_by { |r| DateTime.parse(r[column]).strftime('%Y-%m-%d') }
end

def group_by_file(rows, column)
  rows.group_by { |r| r[column] }
end

# add filename to row with missing filename
# e.g., "bitstream","","62440","","",""...
# to "bitstream","","62440","ORIGINAL","3","ec1621-e.pdf"...
def add_filename_to_rows(rows, bitstream_filename_csv)
  csv_file = File.join(File.dirname(__FILE__), bitstream_filename_csv)
  lines = CSV.read(csv_file, headers: true, encoding: 'ISO-8859-1:UTF-8').map(&:to_hash)
  rows.each do |row|
    if row[0].casecmp('bitstream') == 0
      bitstream_id = row[2]
      filename = row[5]
      if filename.nil? || filename.empty?
        puts "Processing filename #{bitstream_id}"
        row[5] = lines.select{ |l| l['bitstream_id'].casecmp(bitstream_id).zero? }.map{ |l| l['name'] }.first
      end
    end 
  end
end

