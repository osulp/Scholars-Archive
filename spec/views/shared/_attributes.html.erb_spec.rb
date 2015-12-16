require 'rails_helper'
require 'spec_helper'
RSpec.describe "shared/_attributes.html.erb" do

  it "should render nested authors" do
    g = GenericFile.new
    g.nested_authors.build
    g.nested_authors.build
    g.nested_authors.first.name = "Test"
    g.nested_authors.last.name = "Trey"
    g.tag = []
    document = SolrDocument.new(g.to_solr)
    allow(document).to receive(:tag_list) { [] }
    render :partial => "shared/attributes", :locals => {:work => document}

    expect(rendered).to have_content "Author: Test, Trey"
  end

end
