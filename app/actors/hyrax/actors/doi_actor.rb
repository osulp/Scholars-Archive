# frozen_string_literal: true

module Hyrax
  module Actors
    ##
    # An actor that registers a DOI using the configured registar
    # This actor should come after the model actor which saves the work
    #
    # @example use in middleware
    #   stack = ActionDispatch::MiddlewareStack.new.tap do |middleware|
    #     # middleware.use OtherMiddleware
    #     middleware.use Hyrax::Actors::DOIActor
    #     # middleware.use MoreMiddleware
    #   end
    #
    #   env = Hyrax::Actors::Environment.new(object, ability, attributes)
    #   last_actor = Hyrax::Actors::Terminator.new
    #   stack.build(last_actor).create(env)
    class DOIActor < BaseActor
      delegate :destroy, to: :next_actor

      ##
      # @return [Boolean]
      #
      # @see Hyrax::Actors::AbstractActor
      def create(env)
        # Assume the model actor has already run and saved the work
        create_or_update_doi(env.curation_concern) && next_actor.create(env)
      end

      ##
      # @return [Boolean]
      #
      # @see Hyrax::Actors::AbstractActor
      def update(env)
        # OVERRIDE: Remove extra save causing nested fields to duplicate

        create_or_update_doi(env.curation_concern) && next_actor.update(env)
      end

      private

      def create_or_update_doi(work)
        return true unless doi_enabled_work_type?(work) && Flipflop.enabled?(:doi_minting) && valid_public_status?(work)

        Hyrax::DOI::RegisterDOIJob.perform_later(work, registrar: work.doi_registrar.presence, registrar_opts: work.doi_registrar_opts)
      end

      # Check if work is DOI enabled
      def doi_enabled_work_type?(work)
        work.class.ancestors.include? Hyrax::DOI::DOIBehavior
      end

      # FIXME: Find a way to push this into the registrar since it is Datacite specific
      # Check that requested doi_status_when_public is valid
      def valid_public_status?(work)
        !work.respond_to?(:doi_status_when_public) || work.doi_status_when_public.in?(Hyrax::DOI::DataCiteRegistrar::STATES)
      end
    end
  end
end
