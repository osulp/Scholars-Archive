require 'rails_helper'

RSpec.describe "records/show_fields/_nested_geo_points.html.erb" do
  it "should display the nested geo point label" do
    file = object_double(GenericFile.new)
    allow(file).to receive(:[]).with(:nested_geo_points).and_return (
      [
        {
          "id" => "testid",
          "label" => ["Corvallis"],
          "latitude" => ["123.0"],
          "longitude" => ["456"],
        }
      ]
    )
    record = FilePresenter.new(file)

    render :partial => "records/show_fields/nested_geo_points", :locals => {:record => record}

    expect(rendered).to have_content "Corvallis"
  end
end

