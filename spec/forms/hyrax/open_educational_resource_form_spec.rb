require 'rails_helper'

RSpec.describe Hyrax::OpenEducationalResourceForm do

  let(:new_form) { described_class.new(OpenEducationalResource.new, nil, double("Controller")) }

  it "responds to terms with the proper list of terms" do
    expect(described_class.terms).to include *[:resource_type, :is_based_on_url, :interactivity_type, :learning_resource_type, :typical_age_range, :time_required, :duration]
  end

  it "responds to date_terms" do
    expect(described_class).to respond_to :date_terms
  end

end
