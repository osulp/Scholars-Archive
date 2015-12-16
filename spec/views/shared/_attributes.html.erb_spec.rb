require 'rails_helper'
require 'spec_helper'
RSpec.describe "shared/_attributes.html.erb" do

  let(:water) { Hash["id" => "http://id.loc.gov/authorities/subjects/sh85145447", "preflabel" => "Water"] }
  let(:fire) { Hash["id" => "http://id.loc.gov/authorities/subjects/sh85048449", "preflabel" => "Fire"] }
  let(:water_link_uri) { link_to(water['preflabel'], water['id']) }
  let(:fire_link_uri) { link_to(fire['preflabel'], fire['id']) }
  let(:file) { GenericFile.new } 

  it "should render nested authors" do
    file.nested_authors.build
    file.nested_authors.build
    file.nested_authors.first.name = "Test"
    file.nested_authors.last.name = "Trey"

    document = SolrDocument.new(file.to_solr)
    allow(document).to receive(:tag_list) { [] }
    render :partial => "shared/attributes", :locals => {:work => document}
    expect(rendered).to have_content "Author: Test, Trey"
  end

  it "should render label uris" do
    document = SolrDocument.new(file.to_solr)
    allow(document).to receive(:tag_list) { [water, fire] }
    allow_any_instance_of(SufiaHelper).to receive(:link_to_fields).and_return([water_link_uri,fire_link_uri])
    render :partial => "shared/attributes", :locals => {:work => document}
    expect(rendered).to have_content "Water"
    expect(rendered).to have_content "Fire"
  end
end
