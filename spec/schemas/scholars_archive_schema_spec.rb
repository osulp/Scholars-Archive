require 'rails_helper'

RSpec.describe ScholarsArchiveSchema do
  before do
    class SufiaSchemaContainer < ActiveFedora::Base
      include Sufia::GenericFile::Metadata
    end
  end
  after do
    Object.send(:remove_const, "SufiaSchemaContainer")
  end
  it "should not conflict with the Sufia schema" do
    schema_predicates = described_class.properties.map(&:predicate)
    sufia_predicates = SufiaSchemaContainer.properties.values.map(&:predicate)

    expect(schema_predicates & sufia_predicates).to eq []
  end
end
