# frozen_string_literal: true

module ScholarsArchive
  class HandleErrorLoggingService
    def self.log_no_files_found_error(handle_params, work, handle_url)
      logger = Logger.new("#{Rails.root}/log/handle_errors.log")
      logger.warn('WARNING: MISSING_FILES_ERROR')
      logger.warn('========================================================================================================================')
      logger.warn("No file was found for the work #{work.title} for the direct download link provided.")
      logger.warn("Handle Url: #{handle_url}}")
      logger.warn("ir.library.oregonstate.edu/bitstream/handle/#{handle_params[:handle_prefix]}/#{handle_params[:handle_localname]}/#{handle_params[:file]}.#{handle_params[:format]}")
    end

    def self.log_too_many_files_found_error(handle_params, work, handle_url)
      logger = Logger.new("#{Rails.root}/log/handle_errors.log")
      logger.warn('WARNING: TOO_MANY_FILES_ERROR')
      logger.warn('========================================================================================================================')
      logger.warn('Multiple files were found with the same file name. Cannot decide which file to use.')
      logger.warn("#{work.title} was the original work from handle #{handle_url}")
      logger.warn("ir.library.oregonstate.edu/bitstream/handle/#{handle_params[:handle_prefix]}/#{handle_params[:handle_localname]}/#{handle_params[:file]}.#{handle_params[:format]}")
    end

    def self.log_incorrect_handle_prefix_error(handle_params)
      logger = Logger.new("#{Rails.root}/log/handle_errors.log")
      logger.warn('WARNING: INCORRECT_HANDLE_PREFIX_ERROR')
      logger.warn('========================================================================================================================')
      logger.warn('The handle id that was provided was incorrect')
      logger.warn("Handle LOCALNAME: #{handle_params[:handle_prefix]}")
    end

    def self.log_no_work_found_error(handle_params)
      logger = Logger.new("#{Rails.root}/log/handle_errors.log")
      logger.warn('WARNING: NO_WORK_FOUND_ERROR')
      logger.warn('========================================================================================================================')
      logger.warn('The LOCALNAME that was provided was incorrect')
      logger.warn("LOCALNAME: #{handle_params[:handle_localname]}")
    end
  end
end
