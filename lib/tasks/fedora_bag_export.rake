# Export binaries and metadata from Hyrax/Fedora Commons in Bags
# An example: fileset 2z10wq31x has its immediate parent work sf268524q
# the script will create a directory sf268524q, and two directories in it
# sf268524q and 2z10wq31x that correspond to two Bags
# The script works as follows
# query Solr with to get all works of an adminset (fileset does not have adminset)
# foreach work
#   get all its filesets 
#   foreach fileset object
#       use in_works to get its parent
#       create a directory named by in_work id
#       create in_work Bag in_work/in_work directory
#       create fileset Bag in_work/fileset directory
#   end
# end
namespace :scholars_archive do
  desc 'Generate Bags for MetaArchive Preservation'
  task :fedora_bag_export => :environment do
    export_dir_path = '/data0/hydra/shared/tmp/fedora_bag_export/exports/'
    jar_dir_path = '/usr/local/deploy-rails/tmp/import-export/'
    admin_set_tesim = 'Graduate Thesis or Dissertation'
    export_bag(export_dir_path, jar_dir_path, admin_set_tesim)
  end

  def export_bag(export_dir_path, jar_dir_path, admin_set_tesim)
    # Create logger
    datetime_today = DateTime.now.strftime('%m-%d-%Y-%H-%M-%p') # "10-27-2017-12-59-PM"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/fedora-bag-export-#{datetime_today}.log")
    logger.info "Generate Bags for MetaArchive Preservation"
    counter = 0
    counter_skip = 0

    jar_file_path = File.join(jar_dir_path, 'fcrepo-import-export-0.1.0.jar')
    bag_config_path = File.join(jar_dir_path, 'metadata.yml')
    puts 'Exporting Fedora Works in Bags'
    solr_query_str = "admin_set_tesim:\"#{admin_set_tesim}\""
    docs = ActiveFedora::SolrService.query(solr_query_str, {rows: 100000, fl: 'has_model_ssim,id'})
    
    #perform export
    docs.each do |doc|
      logger.info "ready to export bag for work #{doc["id"]} in admin_set \"#{admin_set_tesim}\""

      # undefined method id for an array, indicates in the loop in_works return should be .first.id
      # use puts inspect to find out
      begin
        work_model = doc["has_model_ssim"].first.constantize
        work = work_model.find(doc["id"])
        #find all filesets
        filesets = extract_all_filesets(work)
        filesets.each do |fileset|
          # find fileset immediate parent
          parent_work = fileset.in_works.first
          parent_id = parent_work.id
          # resource_id is used by import-export jar
          resource_id_parent = create_resource_id(parent_id)
          # create Bag export directory, i.e., /usr/local/deploy-rails/tmp/import-export/exports/
          bag_dir_path = File.join(export_dir_path, parent_id)
          Dir.mkdir(bag_dir_path) unless Dir.exist?(bag_dir_path)
          # create export directory for work, i.e., /usr/local/deploy-rails/tmp/import-export/exports/zw12z9519
          parent_dir_path = File.join(bag_dir_path, parent_id)
          # TODO
          # only exporting Bags of work and fileset if parent_dir_path DOES NOT exist
          # it picks up where the process stops (server kill the process because overload)
          if Dir.exist?(parent_dir_path)
            logger.info "\t Skip exporting bags for work: #{parent_id} because it already exists"
            counter_skip += 1
          else 
            Dir.mkdir(parent_dir_path)           
            command = "java -jar #{jar_file_path} --mode export --resource #{resource_id_parent} --dir #{parent_dir_path} --binaries --bag-profile default --bag-config #{bag_config_path}"  
            # create parent Bag
            message = system(command)
            sleep(0.2)
            logger.info "\t Start exporting bags for work: #{parent_id}"
            logger.info "\t #{message}"
            counter += 1
            # create fileset Bag
            fileset_id = fileset.id
            resource_id_fileset = create_resource_id(fileset_id)
            # create export directory for fileset
            fileset_dir_path = File.join(bag_dir_path, fileset_id)
            Dir.mkdir(fileset_dir_path) unless Dir.exist?(fileset_dir_path)
            command0 = "java -jar #{jar_file_path} --mode export --resource #{resource_id_fileset} --dir #{fileset_dir_path} --binaries --bag-profile default --bag-config #{bag_config_path}"  
            message = system(command0)
            sleep(0.2)
            logger.info "\t Start exporting bags for fileset: #{fileset_id}"
            logger.info "\t #{message}"
            counter += 1
          end
        end

      rescue => e
        logger.info "\t failed to export Bag for work id: #{doc["id"]}, title: #{work.title.first}, error found:"
        logger.info "\t #{e.message}"
      end
      logger.info "\t Complete export Bags for work and fileset"
      logger.info "\t Create Bags: #{counter}"
      logger.info "\t Skip Bags: #{counter_skip}"
    end
    logger.info "\t DONE!"
    logger.info "\t Total Create Bags: #{counter}"
    logger.info "\t Total Skip Bags: #{counter_skip}"
  end
  
  # originally developed at https://github.com/osulp/Scholars-Archive/blob/master/app/controllers/scholars_archive/handles_controller.rb#L96
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
  
  # convery Hyrax id e.g., 7h149v54v
  # to reosurce id used by import-export jar e.g., http://localhost:8080/fcrepo/rest/prod/7h/14/9v/54/7h149v54z
  def create_resource_id(id)
    # replace rest/prod with rest/staging for testing on stage1
    return 'http://localhost:8080/fcrepo/rest/prod/'+id[0,8].gsub(/(.{2})/, '\1/')+id
  end
end