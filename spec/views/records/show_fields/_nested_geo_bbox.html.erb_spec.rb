require 'rails_helper'

RSpec.describe "records/show_fields/_nested_geo_bbox.html.erb" do
  it "should display the nested bounding box label" do
    file = object_double(GenericFile.new)
    allow(file).to receive(:[]).with(:nested_geo_bbox).and_return (
      [
        {
          "id" => "testid",
          "label" => ["Corvallis"],
          "bbox_lat_north" => ["123.0"],
          "bbox_lon_west" => ["456"],
          "bbox_lat_south" => ["789"],
          "bbox_lon_east" => ["12345"]
        }
      ]
    )
    record = FilePresenter.new(file)

    render :partial => "records/show_fields/nested_geo_bbox", :locals => {:record => record}

    expect(rendered).to have_content "Corvallis"
  end
end

