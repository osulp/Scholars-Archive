require 'linkeddata'
require 'rest_client'

module ScholarsArchive
  module Controlled
    def fetch
      byebug
      return unless rdf_label == [rdf_subject.to_s] || rdf_label.empty? || rdf_label.length > 1
      super
    end
  end
end
