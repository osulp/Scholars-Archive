# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::OpenEducationalResourceForm do
  let(:new_form) { described_class.new(OpenEducationalResource.new, nil, double('Controller')) }
  let(:user) do
    User.new(email: 'test@example.com', guest: false) { |u| u.save!(validate: false) }
  end
  let(:ability) { double('Ability') }

  before do
    allow(new_form).to receive(:current_ability).and_return(ability)
    allow(ability).to receive(:current_user).and_return(user)
  end

  it 'responds to terms with the proper list of terms' do
    expect(described_class.terms).to include *%i[resource_type is_based_on_url interactivity_type learning_resource_type typical_age_range time_required duration]
  end

  it 'responds to date_terms' do
    expect(described_class).to respond_to :date_terms
  end
end
