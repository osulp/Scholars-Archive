# frozen_string_literal: true

require 'zip'
require 'tar/reader'
require 'down'
require 'csv'

# RAKE TASK: Create a rake task to give report on files that are archive/container & in torrent formats
namespace :scholars_archive do
  desc "FileSets inventory check within container/archives & torrent files"
  task filesets_inventory_check: :environment do
    # DISPLAY: Create status to show where the process is running
    puts "Running ScholarsArchive::FilesetsInventoryCheck"

    # MAILER: Disable mailer so File Inventory won't send out email while running check
    ActionMailer::Base.perform_deliveries = false

    # DISPLAY: Display out that we are looping through each filesets
    puts "Checking each filesets for either container/torrent... .. ."

    # VARIABLE: Setup an array to hold the value for mailing
    email_data, fail_data = [], []

    # LOOP: Go through each filesets in SA
    ::FileSet.find_each do |file_set|
      # CHECK: To see if :mime_type exist
      check_type = file_set.try(:mime_type) rescue nil

      # CONDITION: Check to see if the condition match of the case of format
      email_data << check_container(file_set) if ((!check_type.blank?) && file_set.mime_type.include?('application'))
    end

    # DISPLAY: Done message for checking filesets
    puts "DONE - Finish checking filesets ✓"

    # DISPLAY: Add message for fetching any fail_data
    puts "Checking to see if there's any fail file(s)... .. ."

    # LOOP: Loop through and check for fail id and store them separately
    email_data.each do |data|
        data.delete_if do |e|
          if e.split('$').length == 3
            fail_data << e
            true
          end
        end
    end

    # DISPLAY: Done message for checking filesets that fail
    puts "DONE - Finish checking filesets that fail ✓"

    # DISPLAY: Add message about sending email
    puts "Now composing email to send out the report... .. ."

    # CREATE: Make a .txt file
    create_csv_file(email_data, fail_data)

    # CREATE: Add in a zip file
    create_zip_file

    # MAILER: Enable mailer so Container can send out the email now
    ActionMailer::Base.perform_deliveries = true

    # GET: Retrieve admin email address
    user_email = ENV.fetch('SCHOLARSARCHIVE_ADMIN_EMAIL', 'scholarsarchive@oregonstate.edu')

    # DELIVER: Delivering the email
    ScholarsArchive::ContainerMailer.with(to: user_email).report_email.deliver_now

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
    # DATA: A tmp data storage for info & get the file ids & title
    data_info, tmp = [], []
    counter = 0
    file_id = container.id.to_s
    title = container.title.first.to_s

    # GET: Get the file via URI from Fedora
    fileset = container.files.first
    fileset_uri = fileset.uri.to_s

    # READ: Read the file content
    zip_fileset = URI.open(fileset_uri) { |f| f.read }

    # READ: Now open up the .zip file
    begin
      Zip::File.open_buffer(zip_fileset) do |zip_file|
        # DATA: Handle reading entries one by one
        zip_file.each do |entry|
          if entry.size != 0
            format_type = entry.name.split('.')
            tmp << "#{file_id}$#{title}$0$#{entry.name}$#{format_type.last.downcase}$#{entry.size}"
            counter += 1
          end
        end
      end
    rescue => e
      tmp << "#{file_id}$#{title}$#{e.message}"
    end

    # MAP: Map out the entire array and replace it with the total number of item in files
    tmp.map! { |i| i.sub('$0$', "$#{counter}$") } if (tmp.split('$').length != 3)

    # RETURN: Return the data that was collected
    data_info = tmp.dup
  end

  # METHOD: Create a method to read gzip file
  def gzip_reading(container)
    # DATA: A tmp data storage for info & get the file ids & title
    data_info, tmp = [], []
    file_id = container.id.to_s
    title = container.title.first.to_s

    # GET: Get the file via URI from Fedora
    fileset = container.files.first
    fileset_uri = fileset.uri.to_s

    # READ: Read the file content
    begin
      gzip_fileset = Down.open(fileset_uri)

      # MOVE: Move to the end to obtain only the ISIZE data
      gzip_fileset.seek(-4, 2)
      # READ: Read the needed data and decode it to unsigned int to get the actually size within the GZIP
      size = gzip_fileset.read(4).unpack1('I')

      # CREATE: Add the data into the array for later usage for report
      parse_title = container.title.first.gsub('.gz', '')
      format_type = parse_title.split('.')
      tmp << "#{file_id}$#{title}$1$#{parse_title}$#{format_type.last.downcase}$#{size}"
    rescue => e
      tmp << "#{file_id}$#{title}$#{e.message}"
    end

    # RETURN: Return the data that was collected
    data_info = tmp.dup
  end

  # METHOD: Create a method to read tar file
  def tar_reading(container)
    # DATA: A tmp data storage for info & get the file ids & title
    data_info, tmp = [], []
    counter = 0
    file_id = container.id.to_s
    title = container.title.first.to_s

    # GET: Get the file via URI from Fedora
    fileset = container.files.first
    fileset_uri = fileset.uri.to_s

    # READ: Now open up the .tar file
    URI.open(fileset_uri) do |file|
      begin
        Tar::Reader.new(file).each do |entry|
          if entry.header.size != 0
            format_type = entry.header.path.split('.')
            tmp << "#{file_id}$#{title}$0$#{entry.header.path}$#{format_type.last.downcase}$#{entry.header.size}"
            counter += 1
          end
        end
      rescue => e
        tmp << "#{file_id}$#{title}$#{e.message}"
      end
    end

    # MAP: Map out the entire array and replace it with the total number of item in files
    tmp.map! { |i| i.sub('$0$', "$#{counter}$") } if (tmp.split('$').length != 3)

    # RETURN: Return the data that was collected
    data_info = tmp.dup
  end

  # METHOD: Create a file to attach to email
  def create_csv_file(email_data, fail_data)
    # CHECK: Check and delete files if exist
    File.delete('./tmp/filesets_inventory.csv') if File.file?('./tmp/filesets_inventory.csv')
    File.delete('./tmp/filesets_failed.csv') if File.file?('./tmp/filesets_failed.csv')

    # LOOP: Go through items and write to file
    CSV.open("./tmp/filesets_inventory.csv", "w+") do |csv|
      if email_data.blank?
        csv << ['None of the filesets inventory have anything to check.']
      else
        csv << ['fileset_pid', 'container_filename', 'files_in_container', 'filename', 'format', 'size_in_bytes']
        email_data.each do |data|
          next if data.blank?
          data.each do |item|
            csv_str = item.split('$')
            csv_str = csv_str.map { |s| s.encode(Encoding.find('UTF-8'), {invalid: :replace, undef: :replace, replace: ''}) }
            csv << csv_str
          end
        end
      end
    end

    # LOOP: Go through items and write to file for failed files
    CSV.open("./tmp/filesets_failed.csv", "w+") do |csv|
      if fail_data.blank?
        csv << ['None of the filesets inventory have anything that failed.']
      else
        csv << ['fileset_pid', 'container_filename', 'error_message']
        fail_data.each do |data|
          next if data.blank?
          csv_str = data.split('$')
          csv_str = csv_str.map { |s| s.encode(Encoding.find('UTF-8'), {invalid: :replace, undef: :replace, replace: ''}) }
          csv << csv_str
        end
      end
    end
  end

  # METHOD: Create a zip file to reduce down the size while sending
  def create_zip_file
    # CHECK: Check if file exist if not create a new one
    File.delete('./tmp/filesets_inventory.zip') if File.file?('./tmp/filesets_inventory.zip')
    zip_file = File.new("./tmp/filesets_inventory.zip", "w+")

    # ZIP: Add file and zip them together
    Zip::File.open(zip_file.path, Zip::File::CREATE) do |zip|
      zip.add('filesets_inventory.csv', './tmp/filesets_inventory.csv')
      zip.add('filesets_failed.csv', './tmp/filesets_failed.csv')
    end
  end
end
