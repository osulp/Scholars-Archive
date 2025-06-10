# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource ExternalDataset`
require 'rails_helper'
require 'hyrax/specs/shared_specs/indexers'

RSpec.describe ExternalDatasetIndexer do
  let(:indexer_class) { described_class }
  let(:resource) { ExternalDataset.new }

  it_behaves_like 'a Hyrax::Resource indexer'
end
