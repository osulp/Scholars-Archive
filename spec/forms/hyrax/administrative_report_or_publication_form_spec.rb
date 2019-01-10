# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::AdministrativeReportOrPublicationForm do
  let(:user) do
    User.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false)}
  end
  let(:new_form) { described_class.new(AdministrativeReportOrPublication.new, nil, double('Controller')) }
  let(:ability) {double('Ability')}

  before do
    allow(new_form).to receive(:current_ability).and_return(ability)
    allow(ability).to receive(:current_user).and_return(user)
  end

  it 'responds to terms with the proper list of terms' do
    expect(described_class.terms).to include *[:doi, :alt_title, :nested_ordered_abstract, :license, :based_near, :resource_type, :date_available, :date_copyright, :date_issued, :date_collected, :date_valid, :date_reviewed, :date_accepted, :replaces, :hydrologic_unit_code, :funding_body, :funding_statement, :in_series, :tableofcontents, :bibliographic_citation, :peerreviewed, :nested_ordered_additional_information, :digitization_spec, :file_extent, :file_format, :dspace_community, :dspace_collection]
  end

  it 'has the proper required fields' do
    expect(described_class.required_fields).to include :resource_type
  end

  it 'has the proper primary terms' do
    expect(new_form.primary_terms).to include *[:doi, :alt_title, :nested_ordered_abstract, :subject, :license]
  end

  it 'has the proper secondary terms' do
    expect(new_form.secondary_terms).to_not include *[:license, :resource_type, :subject]
  end

  it 'responds to date_terms' do
    expect(described_class).to respond_to :date_terms
  end
end
