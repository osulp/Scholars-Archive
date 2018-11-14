# frozen_string_literal: true

# Export binaries and metadata from Hyrax/Fedora Commons in Bags for preservation
# Given a list of works created by Solr (like sf268524q), the script will:
# create a directory sf268524q
# download binaries of all its filesets
# save metadata of work and its children works to bagit-infor.txt
# The script works as follows
# get works list and has_model from argument
# foreach work
#   create a directory named by work_id
#   get all its filesets
#   foreach fileset object
#       get its download link
#       download bitstream to directory work_id/data
#   end
#   get all children works
#   foreach child work
#     save work metadata to bagit-infor.txt
#   end
#   call bagit
# end
namespace :scholars_archive do
  desc 'Generate Bags for Preservation'
  task fedora_bag_export: :environment do
    require 'bagit'
    bag_export_path = File.join(Rails.root, 'tmp')
    export_work_list = ENV['workids_list']
    has_model_ssim = ENV['has_model_ssim']
    fedora_bag_export(bag_export_path, export_work_list, has_model_ssim)
  end

  def fedora_bag_export(bag_export_path, export_work_list, has_model_ssim)
    # Create logger
    datetime_today = DateTime.now.strftime('%m-%d-%Y-%H-%M-%p') # "10-27-2017-12-59-PM"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/bag-export-#{datetime_today}.log")
    logger.info 'Generate Bags for Preservation: '
    counter = 0

    workids_file = File.join(File.dirname(__FILE__), workids_list)
    work_to_export = []
    File.readlines(workids_file).each do |line|
      work_to_export.push(line.chomp.strip)
    end
    work_to_export.sort!
    logger.info "A total of #{work_to_export.length} Fedora works to export."

    # Perform export
    # to run test locally: prefix RAILS_ENV=development
    work_to_export.each do |work_id|
      logger.info "Export work #{work_id}"
      # create BagIt directory
      bag_dir_path = File.join(bag_export_path, work_id)
      Dir.mkdir(bag_dir_path) unless Dir.exist?(bag_dir_path)
      bag_data_dir_path = File.join(bag_dir_path, 'data')
      Dir.mkdir(bag_data_dir_path) unless Dir.exist?(bag_data_dir_path)
      baginfo_path = File.join(bag_dir_path, 'bag-info.txt')
      begin
        work_model = has_model_ssim.constantize
        work = work_model.find(work_id)
        # find all filesets
        filesets = extract_all_filesets(work)
        filesets.each do |fileset|
          download_link = 'https://ir.library.oregonstate.edu/downloads/' + fileset.id.to_s
          filename = fileset.label
          if fileset.embargo_id.present?
            logger.warn "#{work_id}, #{fileset} is embargoed"
          else
            command = "curl #{download_link} -o #{bag_data_dir_path}/#{filename}"
            system(command)
            logger.info "\t #{command}"
            logger.info "\t Download bitstream #{fileset.id}, #{filename}"
          end
        end
        # find all children works
        childrenworks = extract_all_children(work)
        # export work metadata to bagit-info.txt
        logger.info "\t Save work metadata #{work.id}"
        info_str = ''
        work.attribute_names.sort.each do |attr|
          info_str += work.attr + "\n"
        end
        File.open(baginfo_path, 'a') { |file| file.write(info_str) }
        childrenworks.each do |child|
          info_str = ''
          child.attribute_names.sort.each do |attr|
            info_str += child.attr + "\n"
          end
          File.open(baginfo_path, 'a') { |file| file.write(info_str) }
        end
        logger.info "\t Create Bag"
        bag = BagIt::Bag.new(bag_dir_path)
        bag.manifest!
        counter += 1
      rescue StandardError => e
        logger.warn "\t failed to export Bag for work #{work.id}, error found:"
        logger.warn "\t #{e.message}"
      end
      logger.info "\t Created Bags: #{counter}"
    end
    logger.info 'DONE!'
    logger.info "Total Created Bags: #{counter}"
  end

  # originally developed at https://github.com/osulp/Scholars-Archive/blob/master/app/controllers/scholars_archive/handles_controller.rb#L96
  def extract_all_filesets(work)
    filesets = []
    work.members.each do |member|
      filesets << extract_all_filesets(member) if member.class.to_s != 'FileSet'
      filesets << member if member.class.to_s == 'FileSet'
    end
    filesets.flatten.compact
  end

  def extract_all_children(work)
    children = []
    work.members.each do |member|
      if member.class.to_s != 'FileSet'
        children << member
        children << extract_all_children(member)
      else
        skip
      end
    end
  end
end
