module ScholarsArchive
  module WorksControllerBehavior
    extend ActiveSupport::Concern
    include Hyrax::WorksControllerBehavior

    included do
      before_action :set_geo, only: [:create, :update]
    end

    def edit
      parse_geo
      super
    end

    private

    def set_geo
      if params[hash_key_for_curation_concern]['nested_geo_attributes']
        params[hash_key_for_curation_concern]['nested_geo_attributes'].each do |box, value|
          if [value["label"], value["bbox_lat_north"], value["bbox_lon_west"], value["bbox_lat_south"], value["bbox_lon_east"]].none? { |f| !f.present? }
            bbox = [value["bbox_lat_north"], value["bbox_lon_west"], value["bbox_lat_south"], value["bbox_lon_east"]]
            value["bbox"] = bbox.join(',')
          end
          if [value["label"], value["point_lat"], value["point_lon"]].none? { |f| !f.present? }
            point = [value["point_lat"], value["point_lon"]]
            value["point"] = point.join(',')
          end
        end
      end
    end

    def parse_geo
      curation_concern.nested_geo.each do |geo|
        if geo.bbox.present?
          # bbox is stored as a string array of lat/long string arrays like: '["121.1", "121.2", "44.1", "44.2"]', however only one array of lat/long array is stored, so the first will need to be converted to simple array of strings like: ["121.1","121.2","44.1","44.2"]
          box_array = geo.bbox.to_a.first.tr('[]" ','').split(',')
          geo.bbox_lat_north = box_array[0]
          geo.bbox_lon_west = box_array[1]
          geo.bbox_lat_south = box_array[2]
          geo.bbox_lon_east = box_array[3]
          geo.type = :bbox.to_s
        end
        if geo.point.present?
          # point is stored as a string array of lat/long string arrays like: '["121.1", "121.2"]', however only one array of lat/long array is stored, so the first will need to be converted to simple array of strings like: ["121.1","121.2"]
          point_array = geo.point.to_a.first.tr('[]" ','').split(',')
          geo.point_lat = point_array[0]
          geo.point_lon = point_array[1]
          geo.type = :point.to_s
        end
      end
    end
  end
end
