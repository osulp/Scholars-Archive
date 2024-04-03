# frozen_string_literal: true

require 'zip'
require 'tar/reader'

# RAKE TASK: Create a rake task to give report on files that are archive/container & in torrent formats
namespace :scholars_archive do
  desc "FileSets inventory check within container/archives & torrent files"
  task filesets_inventory_check: :environment do
    # DISPLAY: Create status to show where the process is running
    puts "Running ScholarsArchive::FilesetsInventoryCheck"

    # MAILER: Disable mailer so File Inventory won't send out email while running check
    ActionMailer::Base.perform_deliveries = false

    # SETUP: Create an array fill with common file size to be check
    file_check = ['application/zip✓', 'application/x-gzip', 'application/x-tar✓', 'application/x-7z-compressed✓', 'application/x-bittorrent']

    # DISPLAY: Display out that we are looping through each filesets
    puts "Checking each filesets for either container/torrent... .. ."

    # VARIABLE: Setup an array to hold the value for mailing
    email_data = []

    # LOOP: Go through each filesets in SA
    ::FileSet.find_each do |file_set|
      # CONDITION: Check to see if the condition match of the case of format
      email_data << check_container(file_set) if file_set.mime_type.include?('application')
    end

    # DISPLAY: Done message for checking filesets
    puts "DONE - Finish checking filesets ✓"
    #puts(email_data.inspect)

    # DISPLAY: Add message about sending email
    puts "Now composing email to send out the report... .. ."

    # MAILER: Enable mailer so Container can send out the email now
    ActionMailer::Base.perform_deliveries = true

    # GET: Retrieve admin email address
    user_email = ENV.fetch('SCHOLARSARCHIVE_ADMIN_EMAIL', 'scholarsarchive@oregonstate.edu')

    # DELIVER: Delivering the email
    ScholarsArchive::ContainerMailer.with(to: user_email, data: email_data).report_email.deliver_now

    # DISPLAY: Done message
    puts "ALL COMPLETE ✓"
  end

  # METHOD: Identify which file ending need to be read base on the mime type
  def check_container(container)
    # SETUP: Data return variable
    data = []

    # CHECK: Go through cases and get data for each file
    case container.mime_type.to_s
    when 'application/zip'
      data = zip_reading(container)
    when 'application/x-7z-compressed'
      data = zip7_reading(container)
    when 'application/x-gzip'
      data = gzip_reading(container)
    when 'application/x-gtar'
      data = tar_reading(container)
    end

    # RETURN: Return the data
    data
  end

  # METHOD: Create a method to read zip file
  def zip_reading(container)
    # DATA: A tmp data storage for info
    data_info = []

    # READ: Now open up the .zip file
    Zip::File.open('./tmp/hi.zip') do |zip_file|
      data_info << "#{container.title.first}$#{zip_file.size}"
      # DATA: Handle reading entries one by one
      zip_file.each do |entry|
        if entry.size != 0
          format_type = entry.name.split('.')
          data_info << "#{entry.name}$#{format_type.last.downcase}$#{entry.size}"
        end
      end
    end

    # RETURN: Return the data that was collected
    data_info
  end

  # METHOD: Create a method to read 7z file
  def zip7_reading(container)
    # DATA: A tmp data storage for info & a counter for total files
    data_info, tmp = [], []
    counter = 0

    # READ: Now open up the .zip file
    File.open("./tmp/A.7z", "rb") do |file|
      SevenZipRuby::Reader.open(file) do |zip7_file|
        # DATA: Handle reading entries one by one
        zip7_file.entries.each do |entry|
          if entry.size != 0
            format_type = entry.path.split('.')
            tmp << "#{entry.path}$#{format_type.last.downcase}$#{entry.size}"
            counter += 1
          end
        end
      end
    end

    # COMBINE: Combine all data into singular array
    data_info << "#{container.title.first}$#{counter}"
    (data_info << tmp).flatten!

    # RETURN: Return the data that was collected
    data_info
  end

  # METHOD: Create a method to read gzip file
  def gzip_reading(container)
    # DATA: A tmp data storage for info & a counter for total files
    data_info, tmp = [], []
    counter = 0

    # READ: Now open up the .zip file
    Zlib::GzipReader.open('./tmp/Transcriptome_annotation.tar.gz') {|gz|
      puts(gz.readbyte)
    }

    # RETURN: Return the data that was collected
    #data_info
  end

  # METHOD: Create a method to read tar file
  def tar_reading(container)
    # DATA: A tmp data storage for info & a counter for total files
    data_info, tmp = [], []
    counter = 0

    # READ: Now open up the .zip file
    File.open("./tmp/osu.tar") do |file|
      Tar::Reader.new(file).each do |entry|
        if entry.header.size != 0
          format_type = entry.header.path.split('.')
          tmp << "#{entry.header.path}$#{format_type.last.downcase}$#{entry.header.size}"
          counter += 1
        end
      end
    end

    # COMBINE: Combine all data into singular array
    data_info << "#{container.title.first}$#{counter}"
    (data_info << tmp).flatten!

    # RETURN: Return the data that was collected
    data_info
  end
end
