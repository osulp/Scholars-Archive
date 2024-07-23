# frozen_string_literal: true

module ScholarsArchive
  module Actors
    # If there is a key `:ext_relation' in the attributes, it extracts the URLs, creates a fileset, addes the URL as metadata, and attaches a dummy image
    # to the work.
    class CreateWithExtRelationActor < Hyrax::Actors::AbstractActor
      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if create was successful
      def create(env)
        ext_relation = env.attributes.delete(:ext_relation)
        next_actor.create(env) && attach_files(env, ext_relation)
      end

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if update was successful
      def update(env)
        ext_relation = env.attributes.delete(:ext_relation)
        next_actor.update(env) && attach_files(env, ext_relation)
      end

      private

      # @param [HashWithIndifferentAccess] ext_relation
      # @return [TrueClass]
      def attach_files(env, ext_relation)
        return true unless ext_relation

        ext_relation.each do |ext|
          next if ext.blank?

          # Escape any space characters, so that this is a legal URI
          uri = URI.parse(Addressable::URI.escape(ext.strip))
          create_file_from_url(env, uri)
        end
        true
      end

      # Utility for creating FileSet from an Ext Relation
      # Used to create a FileSet with a dummy image and store the url into a metadata field
      # rubocop:disable Metrics/MethodLength
      def create_file_from_url(env, uri)
        ext_relation = URI.decode_www_form_component(uri.to_s)
        use_valkyrie = false

        # CASES: Check on curation concern if it is a Valkyrie::Resource
        case env.curation_concern
        when Valkyrie::Resource
          file_set = Hyrax.persister.save(resource: Hyrax::FileSet.new(ext_relation: ext_relation))
          use_valkyrie = true
        else
          file_set = ::FileSet.new(ext_relation: ext_relation)
        end

        actor = Hyrax::Actors::FileSetActor.new(file_set, env.user, use_valkyrie: use_valkyrie)
        actor.create_metadata(visibility: env.curation_concern.visibility)
        actor.attach_to_work(env.curation_concern)
        file_set.save! if file_set.respond_to?(:save!)
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
