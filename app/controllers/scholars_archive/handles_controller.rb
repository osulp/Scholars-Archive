module ScholarsArchive
  class HandlesController < ApplicationController
    before_action :verify_handle_prefix, only: [:handle_show, :handle_download]
    before_action :handle_redirects, only: [:handle_show, :handle_download]
    skip_before_action :check_d2h_http_header_auth

    def handle_file_404
    end

    def handle_work_404
    end

    def handle_show
      work = find_work
      if work.nil?
        ScholarsArchive::HandleErrorLoggingService.log_no_work_found_error(params)
        render "/scholars_archive/handles/handle_work_404.html.erb", status: 404
      else
        redirect_to [main_app, work]
      end
    end

    def handle_download
      work = find_work
      filesets = filesets_for_work(work) unless work.nil?
      if work.nil?
        ScholarsArchive::HandleErrorLoggingService.log_no_work_found_error(params)
        render "/scholars_archive/handles/handle_work_404.html.erb", status: 404
      elsif filesets.empty?
        ScholarsArchive::HandleErrorLoggingService.log_no_files_found_error(params, work, construct_handle_url(params[:handle_prefix], params[:handle_localname]))
        render "/scholars_archive/handles/handle_file_404.html.erb", status: 404, locals: { handle_uri: "#{params[:handle_prefix]}/#{params[:handle_localname]}",
                                                                                            file: "#{params[:file]}.#{params[:format]}",
                                                                                            work_title: work.title,
                                                                                            work_path: "/concern/#{work.class.to_s.pluralize.underscore}/#{work.id}" }
      elsif filesets.length > 1
        ScholarsArchive::HandleErrorLoggingService.log_too_many_files_found_error(params, work, construct_handle_url(params[:handle_prefix], params[:handle_localname]))
        redirect_to [main_app, work]
      else
        redirect_to "/downloads/#{filesets.first.id}"
      end
    end

    private

      def handle_redirects
        new_od_path = od_redirects["handles_od_communities_collections"][params[:handle_localname]]
        if new_od_path
          redirect_to new_od_path and return
        end

        new_od_items_path = od_items_redirects["handles_od_items"][params[:handle_localname]]
        if new_od_items_path
          redirect_to new_od_items_path and return
        end

        new_ir_collections_path = ir_collections_redirects["handles_ir_communities_collections"][params[:handle_localname]]
        if new_ir_collections_path
          redirect_to new_ir_collections_path and return
        end
      end

      def od_redirects
        YAML.load(File.read("config/handles_od_communities_collections.yml"))
      end

      def od_items_redirects
        YAML.load(File.read("config/handles_od_items.yml"))
      end

      def ir_collections_redirects
        YAML.load(File.read("config/handles_ir_communities_collections.yml"))
      end

      def verify_handle_prefix
        if params[:handle_prefix] != "1957"
          ScholarsArchive::HandleErrorLoggingService.log_incorrect_handle_prefix_error(params)
          redirect_to root_path
        end
      end

      def filesets_for_work(work)
        filesets = extract_all_filesets(work)
        solr_filesets = query_solr_for_filesets(construct_fileset_querystring(params[:file], params[:format]))
        solr_fileset_ids = solr_filesets.map { |f| f['id'] }
        filesets.select { |member| solr_fileset_ids.include?(member.id) }
      end

      #Recursive Method. This method will recursively call itself until all
      #the filesets for a given work have been found. If it finds a child work
      #that is not of the FileSet type then it will call itself to pull the
      #filesets out and return them. After it finds all filesets, it returns
      #them.
      #Input: Work of a WorkType that isnt a FileSet
      #Output: An Array of FileSets
      #End of recursion: When a work has successfully gotten through all its
      #members

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

      def find_work
        solr_doc = query_solr_for_work(construct_handle_url(params[:handle_prefix], params[:handle_localname]))
        query_fedora_for_work(solr_doc.first[:id], solr_doc.first[:has_model_ssim].first.constantize) unless solr_doc.empty?
      end

      def construct_handle_url(handle_prefix, handle_localname)
        RSolr.solr_escape("http://hdl.handle.net/#{handle_prefix}/#{handle_localname}")
      end

      # Addressing the variety of incoming HTTP requests with url encoded spaces in filenames
      # Some of the files were uploaded to SA with underscores replacing where there were originally spaces as well.
      # This method aims to make spaces, %20, +, and _ into wildcards to aid in SOLR queries for the FileSets
      def construct_fileset_querystring(file, format)
        "#{file.gsub(' ','*').gsub('%20','*').gsub('_','*').gsub('+','*')}.#{format}"
      end

      def query_fedora_for_work(id, work_type)
        work_type.find(id)
      end

      def query_solr_for_work(handle)
        #Query solr
        ActiveFedora::SolrService.query("replaces_ssim:#{handle}", :rows => 1000000)
      end

      def query_solr_for_filesets(label)
        ActiveFedora::SolrService.query("has_model_ssim:FileSet AND label_ssi:#{label}", :rows => 10000)
      end
  end
end
