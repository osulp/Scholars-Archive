require 'rails_helper'

RSpec.describe Hyrax::GraduateThesisOrDissertationForm do

  let(:new_form) { described_class.new(GraduateThesisOrDissertation.new, nil, double("Controller")) }

  it "responds to terms with the proper list of terms" do
    expect(described_class.terms).to include *[:degree_level, :degree_name, :degree_field, :degree_grantors, :contributor_advisor, :contributor_committeemember, :graduation_year, :degree_discipline]  
  end
  it "has the proper required fields" do
    expect(described_class.required_fields).to include *[:degree_level, :degree_name, :degree_field, :degree_grantors, :graduation_year]
  end

  it "has the proper primary terms" do
    expect(new_form.primary_terms).to include *[:contributor_advisor, :contributor_committeemember]
  end

  it "has the proper secondary terms" do
    expect(new_form.secondary_terms).to include *[:nested_related_items, :hydrologic_unit_code, :geo_section, :funding_statement, :publisher, :peerreviewed, :language, :file_format, :file_extent, :digitization_spec, :replaces, :additional_information, :source, :isbn, :issn]
  end

  it "responds to date_terms" do
    expect(described_class).to respond_to :date_terms
  end
end
