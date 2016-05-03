#property :accepted, :predicate => ::RDF::DC.dateAccepted do |index|
  #  index.as :stored_searchable, :facetable
  #end

  include Sufia::WorkBehavior
  self.human_readable_type = 'Work'
  validates :title, presence: { message: 'Your work must have a title.' }

end
