require 'rails_helper'

RSpec.describe ScholarsArchive::ExtendedFileBasedAuthority  do
  let(:authority) { described_class.new("degree_grantors") }
  let(:terms) {
    [{"id"=>"http://id.loc.gov/authorities/names/n95078079",
      "label"=>"Oregon Agricultural College",
      "active"=>true,
      "admin_only"=>true},
     {"id"=>"http://id.loc.gov/authorities/names/n87850581",
      "label"=>"Oregon State Agricultural College",
      "active"=>true,
      "admin_only"=>true},
     {"id"=>"http://id.loc.gov/authorities/names/n82022628",
      "label"=>"Oregon State College",
      "active"=>true,
      "admin_only"=>true},
     {"id"=>"http://id.loc.gov/authorities/names/n80017721",
      "label"=>"Oregon State University",
      "active"=>true,
      "admin_only"=>false},
     {"id"=>"Other", "label"=>"Other", "active"=>true, "admin_only"=>false}]
  }
  describe "#terms" do
    context "When terms is called" do
      it "should return an array of the all of the terms" do
        expect(authority.all).to eq terms
        expect(authority.all.map{|t| t[:admin_only]}.count).to eq 5
        expect(authority.all.map{|t| t[:admin_only]}.include?(true)).to be_truthy
        expect(authority.all.map{|t| t[:admin_only]}.include?(false)).to be_truthy
      end
    end
  end
end
