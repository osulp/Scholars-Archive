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
        validate(env) && save_custom_option(env) && next_actor.create(env)
      end

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if update was successful
      def update(env)
        validate(env) && update_custom_option(env) && next_actor.update(env)
      end

      private

      def validate(env)
        return true unless degree_present? (env)
        error_counter = 0
        # check if degree_level_other is already in the list
        degree_level_other = env.curation_concern.degree_level_other
        if degree_level_other.present?
          degree_level_service = ScholarsArchive::DegreeLevelService.new
          collection = degree_level_service.select_active_options
          if !collection.select {|option| option.include? degree_level_other}.empty?
            env.curation_concern.errors.add(:degree_level_other, 'This degree level already exists, please select from the list above.')
            error_counter += 1
          end
        else
          if env.attributes['degree_level'] == 'Other'
            env.curation_concern.errors.add(:degree_level_other, "Please provide a value for 'Other' degree level.")
            error_counter += 1
          end
        end

        # check if degree_field_other is already in the list
        degree_field_other = env.curation_concern.degree_field_other
        if degree_field_other.present?
          degree_field_service = ScholarsArchive::DegreeFieldService.new
          collection = degree_field_service.select_active_options
          if !collection.select {|option| option.include? degree_field_other}.empty?
            env.curation_concern.errors.add(:degree_field_other, 'This degree field already exists, please select from the list above.')
            error_counter += 1
          end
        else
          if env.attributes['degree_field'] == 'Other'
            env.curation_concern.errors.add(:degree_field_other, "Please provide a value for 'Other' degree field.")
            error_counter += 1
          end
        end

        (error_counter > 0) ? false : true
      end

      def degree_present? (env)
        env.attributes['degree_field'].present? && env.attributes['degree_level'].present?
      end

      def save_custom_option(env)
        return true unless degree_present? (env)
        if env.curation_concern.degree_field_other.present?
          OtherOption.find_or_create_by(name: env.curation_concern.degree_field_other.to_s, work_id: env.curation_concern.id, property_name: :degree_field.to_s)
        end
        if env.curation_concern.degree_level_other.present?
          OtherOption.find_or_create_by(name: env.curation_concern.degree_level_other.to_s, work_id: env.curation_concern.id, property_name: :degree_level.to_s)
        end
        return true
      end

      def update_custom_option(env)
        return true unless degree_present? (env)
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
