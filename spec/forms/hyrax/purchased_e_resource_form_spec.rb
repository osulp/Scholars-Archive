# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::PurchasedEResourceForm do
  let(:new_form) { described_class.new(PurchasedEResource.new, nil, double('Controller')) }
  let(:user) do
    User.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
  end
  let(:ability) { double('Ability') }

  before do
    allow(new_form).to receive(:current_ability).and_return(ability)
    allow(ability).to receive(:current_user).and_return(user)
  end

  xit 'responds to terms with the proper list of terms' do
    expect(described_class.terms).to include(*%i[resource_type editor has_volume has_number conference_location conference_name conference_section has_journal is_referenced_by])
  end

  it 'responds to date_terms' do
    expect(described_class).to respond_to :date_terms
  end
end
