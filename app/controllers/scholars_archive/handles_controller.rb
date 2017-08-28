module ScholarsArchive
  class HandlesController < ApplicationController
    before_filter :verify_handle_id, only: [:handle_show, :handle_download]
    skip_before_action :check_d2h_http_header_auth

    def handle_file_404
      @handle_uri = "#{params[:handle_id]}/#{params[:id]}"
      @file = "#{params[:file]}"
      work = find_work
      @work_path = "/concern/#{work.class.to_s.downcase.pluralize}/#{work.id}"
    end

    def handle_work_404

    end

    def handle_show
      work = find_work
      if work.nil?
        ScholarsArchive::HandleErrorLoggingService.log_no_work_found_error(params)
        redirect_to "/404/work_not_found"
      else
        redirect_to "/concern/#{work.class.to_s.downcase.pluralize}/#{work.id}"
      end
    end

    def handle_download
      work = find_work
      filesets = filesets_for_work(work) unless work.nil?
      if work.nil?
        ScholarsArchive::HandleErrorLoggingService.log_no_work_found_error(params)
        redirect_to "/404/work_not_found"
      elsif filesets.empty?
        ScholarsArchive::HandleErrorLoggingService.log_no_files_found_error(params, work, construct_handle_url(params[:handle_id], params[:id]))
        redirect_to "/404/file_not_found/#{params[:handle_id]}/#{params[:id]}/#{params[:file]}"
      elsif filesets.length > 1
        ScholarsArchive::HandleErrorLoggingService.log_too_many_files_found_error(params, work, construct_handle_url(params[:handle_id], params[:id]))
        redirect_to "/concern/#{work.class.to_s.downcase.pluralize}/#{work.id}"
      else
        redirect_to "/downloads/#{filesets.first.id}"
      end
    end

    private
      def verify_handle_id
        if params[:handle_id] != "1957"
          ScholarsArchive::HandleErrorLoggingService.log_incorrect_handle_id_error(params)
          redirect_to root_path
        end
      end

      def filesets_for_work(work)
        filesets = extract_all_filesets(work)
        filesets.select { |member| member.title.include?(params[:file] + "." + params[:format]) }
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
        solr_doc = query_solr_for_work(construct_handle_url(params[:handle_id], params[:id]))
        query_fedora_for_work(solr_doc.first[:id], solr_doc.first[:human_readable_type_tesim].first.constantize) unless solr_doc.empty?
      end

      def construct_handle_url(handle_id, handle_code)
        RSolr.solr_escape("http://hdl.handle.net/#{handle_id}/#{handle_code}")
      end

      def query_fedora_for_work(id, work_type)
        work_type.find(id)
      end

      def query_solr_for_work(handle)
        #Query solr
        ActiveFedora::SolrService.query("replaces_ssim:#{handle}", :rows => 1000000)
      end
  end
end
