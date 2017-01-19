# Generated via
#  `rails generate hyrax:work DefaultWork`
module Hyrax
  class DefaultWorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::DefaultWork
    self.terms += [:orcid, :alternative_title, :date_issued, :date_embargo, :peerreview, :peerreviewnotes, :citation, :ispartofseries, :tableofcontents, :digitization, :relation, :resource_type]
    self.terms -= [:contributor, :date_created, :location, :related_url, :source]
    self.required_fields -= [:keyword, :creator]
  end
end
