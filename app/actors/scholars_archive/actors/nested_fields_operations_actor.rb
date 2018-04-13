module ScholarsArchive
  module Actors
    # The Hyrax::NestedFieldsOperationsActor responds to two primary actions:
    # * #create
    # * #update
    # it must instantiate the next actor in the chain and instantiate it.
    class NestedFieldsOperationsActor < Hyrax::Actors::AbstractActor
      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if create was successful
      def create(env)
        save_nested_elements(env) && next_actor.create(env)
      end

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if update was successful
      def update(env)
        update_nested_elements(env) && next_actor.update(env)
      end

      private

      def nested_geo_present? (env)
        env.attributes['nested_geo_attributes'].present?
      end

      def set_geo_coordinates (env)
        if env.attributes['nested_geo_attributes']
          env.attributes['nested_geo_attributes'].each do |box, value|
            if [value["label"], value["bbox_lat_north"], value["bbox_lon_west"], value["bbox_lat_south"], value["bbox_lon_east"]].none? { |f| !f.present? }
              bbox = [value["bbox_lat_north"], value["bbox_lon_west"], value["bbox_lat_south"], value["bbox_lon_east"]]
              value["bbox"] = bbox.join(',')
            end
            if [value["label"], value["point_lat"], value["point_lon"]].none? { |f| !f.present? }
              point = [value["point_lat"], value["point_lon"]]
              value["point"] = point.join(',')
            end
          end
          clean_up_nested_attributes(env)
        end
      end

      def save_nested_elements(env)
        clean_up_fields(env)
        return true unless nested_geo_present? (env)
        set_geo_coordinates(env)
        return true
      end

      def update_nested_elements(env)
        clean_up_fields(env)
        return true unless nested_geo_present? (env)
        set_geo_coordinates(env)
        return true
      end

      def clean_up_fields (env)
        # Note: since we aren't storing "Other" values in fedora for other_affiliation, here we can skip them
        # for the model and only keep valid uri values. add_other_field_option_actor is responsible for persisting the
        # text values provided by the user for these "Other" entries. Here we are just removing/cleaning up the
        # selection before getting to the ModelActor, which is where the attributes appears to be persisted in fedora
        if env.attributes['other_affiliation']
          env.attributes['other_affiliation'].to_a.delete_if { |x| x == 'Other'}
        end
      end

      def clean_up_nested_attributes (env)
        env.attributes['nested_geo_attributes'].each do |k,v|
          v.delete('point_lon')
          v.delete('point_lat')
          v.delete('bbox_lat_north')
          v.delete('bbox_lon_west')
          v.delete('bbox_lat_south')
          v.delete('bbox_lon_east')
        end
      end

    end
  end
end
