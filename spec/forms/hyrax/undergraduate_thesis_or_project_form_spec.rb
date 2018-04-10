require 'rails_helper'

RSpec.describe Hyrax::UndergraduateThesisOrProjectForm do

  let(:new_form) { described_class.new(UndergraduateThesisOrProject.new, nil, double("Controller")) }
  let(:user) do
    User.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false)}
  end
  before do
    allow(described_class).receive(:current_ability).and_return(user)
  end

  it "responds to terms with the proper list of terms" do
    expect(described_class.terms).to include *[:degree_level, :degree_name, :degree_field, :degree_grantors, :contributor_advisor, :contributor_committeemember, :graduation_year, :degree_discipline]
  end

  it "has the proper primary terms" do
    expect(new_form.primary_terms).to include *[:contributor_advisor, :contributor_committeemember, :degree_level, :degree_name, :degree_field, :degree_grantors, :graduation_year]
  end

  it "has the proper secondary terms" do
    expect(new_form.secondary_terms).to include *[:nested_related_items, :hydrologic_unit_code, :geo_section, :funding_statement, :publisher, :peerreviewed, :language, :file_format, :file_extent, :digitization_spec, :replaces, :additional_information, :isbn, :issn]
  end

  it "responds to date_terms" do
    expect(described_class).to respond_to :date_terms
  end
end
