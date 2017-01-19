# Generated via
#  `rails generate hyrax:work DefaultWork`
module Hyrax
  class DefaultWorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::DefaultWork
    self.terms += [:orcid, :alternative_title, :date_issued, :date_embargo, :peerreview, :peerreviewnotes, :citation, :doi, :identifier_uri, :isbn, :ispartofseries, :tableofcontents, :digitization, :relation, :sponsorship, :funding_statement, :funding_body, :resource_type]
    self.terms -= [:contributor, :based_near, :related_url, :source]
    self.required_fields -= [:keyword, :creator]
  end
end
