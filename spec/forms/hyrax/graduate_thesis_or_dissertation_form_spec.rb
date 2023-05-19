# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::GraduateThesisOrDissertationForm do
  let(:new_form) { described_class.new(GraduateThesisOrDissertation.new, nil, double('Controller')) }
  let(:user) do
    User.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
  end
  let(:ability) { double('Ability') }

  before do
    allow(new_form).to receive(:current_ability).and_return(ability)
    allow(ability).to receive(:current_user).and_return(user)
  end

  it 'responds to terms with the proper list of terms' do
    expect(described_class.terms).to include *%i[degree_level degree_name degree_field degree_grantors contributor_advisor contributor_committeemember graduation_year degree_discipline]
  end

  it 'has the proper required fields' do
    expect(described_class.required_fields).to include *%i[degree_level degree_name degree_field degree_grantors graduation_year]
  end

  it 'has the proper primary terms' do
    expect(new_form.primary_terms).to include *%i[contributor_advisor contributor_committeemember]
  end

  it 'has the proper secondary terms' do
    expect(new_form.secondary_terms).to include *%i[nested_related_items hydrologic_unit_code geo_section funding_statement publisher peerreviewed language file_format file_extent digitization_spec replaces nested_ordered_additional_information isbn issn]
  end

  it 'responds to date_terms' do
    expect(described_class).to respond_to :date_terms
  end
end
