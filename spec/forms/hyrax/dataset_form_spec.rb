require 'rails_helper'

RSpec.describe Hyrax::DatasetForm do

  let(:new_form) { described_class.new(Dataset.new, nil, double("Controller")) }

  it "responds to terms with the proper list of terms" do
    expect(described_class.terms).to include *[:doi, :alt_title, :abstract, :license, :based_near, :resource_type, :date_available, :date_copyright, :date_issued, :date_collected, :date_valid, :date_accepted, :replaces, :hydrologic_unit_code, :funding_body, :funding_statement, :in_series, :tableofcontents, :bibliographic_citation, :peerreviewed, :additional_information, :digitization_spec, :file_extent, :file_format, :dspace_community, :dspace_collection]
  end

  it "has the proper required fields" do
    expect(described_class.required_fields).to include :resource_type
  end

  it "has the proper primary terms" do
    expect(new_form.primary_terms).to include *[:title, :alt_title, :creator, :academic_affiliation, :other_affiliation, :contributor, :abstract, :license, :resource_type, :doi, :bibliographic_citation, :in_series, :subject, :rights_statement]
  end

  it "has the proper secondary terms" do
    expect(new_form.secondary_terms).to_not include *[:license, :resource_type]
  end

  it "responds to date_terms" do
    expect(described_class).to respond_to :date_terms
  end


end
