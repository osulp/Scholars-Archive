# frozen_string_literal: true

# Generated by hyrax:models:install
class FileSet < ActiveFedora::Base
  # PREDICATE: Add in :ext_relation for external resource
  property :ext_relation, predicate: ::RDF::URI.new('http://rioxx.net/schema/v3.0/rioxxterms/#ext_relation'), multiple: false

  include ::ScholarsArchive::DefaultMetadata
  include ::Hyrax::FileSetBehavior
  include ::ScholarsArchive::FinalizeNestedMetadata

  # INDEXER: Tell indexer to run custom file
  self.indexer = ScholarsArchive::FileSetIndexer

  # METHOD: To check true/false if exist for external resource
  def ext_relation?
    !ext_relation.blank?
  end

  private

  def set_defaults; end
end
