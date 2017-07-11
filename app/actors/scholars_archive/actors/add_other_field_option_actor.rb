module ScholarsArchive
  module Actors
    # The Hyrax::AddOtherFieldOptionActor responds to two primary actions:
    # * #create
    # * #update
    # it must instantiate the next actor in the chain and instantiate it.
    class AddOtherFieldOptionActor < Hyrax::Actors::BaseActor
      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if create was successful
      def create(env)
        save_custom_option(env) && next_actor.create(env)
      end

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if update was successful
      def update(env)
        update_custom_option(env) && next_actor.update(env)
      end

      private

      def save_custom_option(env)
        if env.curation_concern.degree_field_other.present?
          OtherOption.find_or_create_by(name: env.curation_concern.degree_field_other.to_s, work_id: env.curation_concern.id, property_name: :degree_field.to_s)
        end
        if env.curation_concern.degree_level_other.present?
          OtherOption.find_or_create_by(name: env.curation_concern.degree_level_other.to_s, work_id: env.curation_concern.id, property_name: :degree_level.to_s)
        end
      end

      def update_custom_option(env)
        if env.curation_concern.degree_field_other.present?
          degree_field_other_option = get_other_option(env, :degree_field)
          if degree_field_other_option.present?
            OtherOption.update(degree_field_other_option.id, name: env.curation_concern.degree_field_other.to_s)
          else
            OtherOption.find_or_create_by(name: env.curation_concern.degree_field_other.to_s, work_id: env.curation_concern.id, property_name: :degree_field.to_s)
          end
        end

        if env.curation_concern.degree_level_other.present?
          degree_level_other_option = get_other_option(env, :degree_level)
          if degree_level_other_option.present?
            OtherOption.update(degree_level_other_option.id, name: env.curation_concern.degree_level_other.to_s)
          else
            OtherOption.find_or_create_by(name: env.curation_concern.degree_level_other.to_s, work_id: env.curation_concern.id, property_name: :degree_level.to_s)
          end
        end
        return true
      end

      def get_other_option(env, field)
        OtherOption.find_by(work_id: env.curation_concern.id, property_name: field.to_s)
      end
    end
  end
end
