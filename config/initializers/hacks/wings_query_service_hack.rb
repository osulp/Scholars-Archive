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
end
