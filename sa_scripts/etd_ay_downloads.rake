# frozen_string_literal: true

# Get total downloads and metadata for ETD works
# Given a list of parent work ids (e.g., ETD), the script will
# - find filesets for each work
# - get downloads for each fileset and calculate total download for each work
# - export the below information to csv
# -   parent work metadata (e.g., work_id, title, degree_name for ETD),
# -   fileset metadata (e.g., file_id, filename, date upload),
# -   total_downloads for work

# Google has quota on how many requests per IP
# "The 10,000 requests per view (profile) per day or the 10 concurrent requests per view (profile) cannot be increased."
# the script will request data from Google for each fileset, so prepare the workids to be processed not to exceed the quota

require 'csv'

namespace :scholars_archive do
  desc "Get Total Downloads for ETD works"
  task etd_ay_downloads: :environment do
    workids_list = ENV['workids_list']
    has_model_ssim = 'GraduateThesisOrDissertation'
    citeable_url = 'https://ir.library.oregonstate.edu/concern/graduate_thesis_or_dissertations/'
    etd_ay_download(workids_list, has_model_ssim, citeable_url)
  end

  def etd_ay_download(workids_list, has_model_ssim, citeable_url)
    workids_file = File.join(File.dirname(__FILE__), workids_list)
    works_to_process = []
    File.readlines(workids_file).each do |line|
      works_to_process.push(line.chomp.strip)
    end
    works_to_process.sort!

    csv_output_path = File.join(Rails.root, 'tmp', 'etd-ay-downloads.csv')
    CSV.open(csv_output_path, 'ab') do |csv|
      csv << ["work_id", "work_title", "graduation_year", "degree_level", "degree_name", "degree_field",
              "academic_affiliation", "degree_grantor", "work_url", "total_downloads"]
      works_to_process.each do |work_id|
        begin
          puts "Processing work: #{work_id}"
          work_model = has_model_ssim.constantize
          work = work_model.find(work_id)
          work_url = citeable_url + work_id
          filesets = extract_all_filesets(work)
          work_downloads = 0
          filesets.each do |fileset|
            fileset_id = fileset.id
            puts "Processing fileset: #{fileset_id}"
            stats = Hyrax::FileUsage.new(fileset_id)
            fileset_downloads = stats.total_downloads
            work_downloads += fileset_downloads
          end
          csv << [work_id, work.title.first, work.graduation_year, work.degree_level, work.degree_name.first,
                  work.degree_field.first, work.academic_affiliation.first, work.degree_grantors, work_url, work_downloads]
        rescue => e
          puts "ERROR with work: #{work_id} : #{e}"
        end
      end
    end
  end

  def extract_all_filesets(work)
    filesets = []
    work.members.each do |member|
      filesets << extract_all_filesets(member) if member.class.to_s != 'FileSet'
      filesets << member if member.class.to_s == 'FileSet'
    end
    filesets.flatten.compact
  end
end
