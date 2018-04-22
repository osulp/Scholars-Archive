# Get total downloads and metadata for fileset and its parent work
# Given a list of parent work ids (e.g., ETD), the script will
# - find filesets for each work
# - get total_downloads for each fileset
# - export the below information to csv
# -   parent work metadata (e.g., work_id, title, degree_name for ETD),
# -   fileset metadata (e.g., file_id, filename, date upload),
# -   total_downloads for fileset

require 'csv'

namespace :scholars_archive do
  desc "Get Total Downloads for Fileset"
  task get_fileset_downloads: :environment do
    workids_list = ENV['workids_list']
    has_model_ssim = ENV['has_model_ssim']
    get_fileset_download(workids_list, has_model_ssim)
  end

  def get_fileset_download(workids_list, has_model_ssim)
    workids_file = File.join(File.dirname(__FILE__), workids_list)
    works_to_process = []
    File.readlines(workids_file).each do |line|
      works_to_process.push(line.chomp)
    end
    works_to_process.sort!

    csv_output_path = File.join(Rails.root, 'tmp', 'total-downloads-fileset.csv')
    CSV.open(csv_output_path, 'ab') do |csv|
      works_to_process.each do |work_id|
        begin
          puts "Processing work: #{work_id}"
          work_model = has_model_ssim.constantize
          work = work_model.find(work_id)
          filesets = extract_all_filesets(work)
          filesets.each do |fileset|
            fileset_id = fileset.id
            puts "Processing fileset: #{fileset_id}"
            stats = Hyrax::FileUsage.new(fileset_id)
            total_downloads = stats.total_downloads
            csv << [work_id, work.title.first, work.graduation_year, work.degree_level, work.degree_name.first,
            work.degree_field.first, work.academic_affiliation.first, work.admin_set.title.first, fileset_id,
            fileset.date_uploaded, fileset.title.first, total_downloads]
          end
        rescue => e
          puts "ERROR processing work: #{work_id} : #{e}"
        end
      end
    end
  end

  def extract_all_filesets(work)
    filesets = []
    work.members.each do |member|
      if member.class.to_s != "FileSet"
        filesets << extract_all_filesets(member)
      else
        filesets << member
      end
    end
    filesets.flatten.compact
  end
end
