# frozen_string_literal: true

# Export binaries and metadata from Hyrax/Fedora Commons in Bags for MetaArchives preservation
# An example: given a list of works created by Solr like work sf268524q
# the script will create a directory sf268524q, download binaries of its filesets
# sf268524q and 2z10wq31x, and save work metadata to bagit-infor.txt
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
    bag_export_path = ENV['bag_export_path']
    export_work_list = ENV['workids_list']
    has_model_ssim = ENV['has_model_ssim']
    fedora_bag_export(bag_export_path, export_work_list, has_model_ssim)
  end

  def fedora_bag_export(bag_export_path, export_work_list, has_model_ssim)
    # Create logger
    datetime_today = DateTime.now.strftime('%m-%d-%Y-%H-%M-%p') # "10-27-2017-12-59-PM"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/fedora-bag-export-#{datetime_today}.log")
    logger.info 'Generate Bags for MetaArchive Preservation: '
    counter = 0

    # Have to careful with the data format because otherwise Fedora will complain with id not found
    # you do not need to wrap id in double quote
    work_to_export = []
    File.readlines(export_work_list).each do |line|
      work_to_export.push(line.chomp)
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
          # get download link e.g., https://ir.library.oregonstate.edu/downloads/1831cq42s
          download_link = 'https://ir.library.oregonstate.edu/downloads/' + fileset.id.to_s
          filename = fileset.label
          if fileset.embargo_id.present?
            logger.warn "#{work_id}, #{fileset.id}, #{fileset} is embargoed"
          else
            command = "curl #{download_link} -o #{bag_data_dir_path}/#{filename}"
            system(command)
            logger.info "Download bitstream #{fileset.id}, #{filename}"
          end
        end
        # find all children works
        childrenworks = extract_all_children(work)
        # export work metadata to bagit-info.txt
        logger.info "\t Save work metadata #{work.id}"
        info_str = 'id: ' + work.id + "\n" + 'title: ' + work.title.first + "\n" + 'admin_set: ' + work.admin_set.title.first + "\n" + 'creator(s): ' + work.creator.join(',')
        File.open(baginfo, 'w') { |file| file.write(info_str) }
        logger.info "\t Create Bag"
        bag = BagIt::Bag.new(bag_dir_path)
        bag.manifest!
        counter += 1
      rescue StandardError => e
        logger.info "\t failed to export Bag for work #{work.id}, error found:"
        logger.info "\t #{e.message}"
      end
      logger.info "Created Bags: #{counter}"
    end
    logger.info 'DONE!'
    logger.info "Total Create Bags: #{counter}"
  end

  # originally developed at https://github.com/osulp/Scholars-Archive/blob/master/app/controllers/scholars_archive/handles_controller.rb#L96
  def extract_all_filesets(work)
    filesets = []
    work.members.each do |member|
      filesets << if member.class.to_s != 'FileSet'
                    extract_all_filesets(member)
                  else
                    member
                  end
    end
  end
end
