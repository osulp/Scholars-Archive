# frozen_string_literal:true

Rails.application.config.to_prepare do
  Wings::Valkyrie::QueryService.class_eval do
    ##
    # Find a record using an alternate ID, and map it to a Valkyrie Resource
    #
    # @param [Valkyrie::ID, String] id
    # @param [boolean] optionally return ActiveFedora object/errors
    #
    # @return [Valkyrie::Resource]
    # @raise [Valkyrie::Persistence::ObjectNotFoundError]
    #
    # Use Hyrax.config.use_valkyrie? instead of constant true
    def find_by_alternate_identifier(alternate_identifier:, use_valkyrie: Hyrax.config.use_valkyrie?)
      raise(ArgumentError, 'id must be a Valkyrie::ID') unless
        alternate_identifier.respond_to?(:to_str)

      af_object = ActiveFedora::Base.find(alternate_identifier.to_s)

      use_valkyrie ? resource_factory.to_resource(object: af_object) : af_object
    rescue ActiveFedora::ObjectNotFoundError, Ldp::Gone => err
      raise err unless use_valkyrie
      raise ::Valkyrie::Persistence::ObjectNotFoundError
    end
  end

  Hyrax::AdminSetCreateService.class_eval do
    class << self

      private

      # Find default AdministrativeSet using DEFAULT_ID.
      # @note Use of hardcoded ID is being deprecated as some Valkyrie adapters
      #       do not support hardcoded IDs (e.g. postgres)
      # @return [Hyrax::AdministrativeSet] the default admin set; nil if not found
      def find_unsaved_default_admin_set
        admin_set = Hyrax.query_service.find_by(id: self::DEFAULT_ID)
        default_admin_set_persister.update(default_admin_set_id: self::DEFAULT_ID) if save_default?
        admin_set
      # Rescue ActiveFedora::ObjectNotFoundError as well
      rescue Valkyrie::Persistence::ObjectNotFoundError, ActiveFedora::ObjectNotFoundError
        # a default admin set hasn't been created yet
      end
    end
  end
end
