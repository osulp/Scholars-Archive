require 'rails_helper'

RSpec.describe "shared/_attributes.html.erb" do
  it "should render nested authors" do
    g = GenericFile.new
    g.nested_authors.build
    g.nested_authors.first.name = "Test"
    document = SolrDocument.new(g.to_solr)

    render :partial => "shared/attributes", :locals => {:work => document}

    expect(rendered).to have_content "Author: Test"
  end
end
