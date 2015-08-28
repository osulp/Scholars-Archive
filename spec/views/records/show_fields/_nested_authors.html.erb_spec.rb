require 'rails_helper'

RSpec.describe "records/show_fields/_nested_authors.html.erb" do
  it "should display the nested author names" do
    file = object_double(GenericFile.new)
    allow(file).to receive(:[]).with(:nested_authors).and_return (
      [
        {
          "id" => "testid",
          "name" => ["Trey Pendragon"],
          "orcid" => ["12345"]
        }
      ]
    )
    record = FilePresenter.new(file)
    
    render :partial => "records/show_fields/nested_authors", :locals => {:record => record}

    expect(rendered).to have_content "Trey Pendragon"
  end
end
