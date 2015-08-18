class NestedAuthor < ActiveTriples::Resource
  property :name, :predicate => RDF::FOAF.name
  property :orcid, :predicate => RDF::URI("http://id.loc.gov/vocabulary/identifiers/orcid")

  def initialize(uri=RDF::Node.new, parent=nil)
    if uri.try(:node?)
      uri = RDF::URI("#author_#{uri.to_s.gsub('_:','')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

  def final_parent
    parent
  end

  def new_record?
    !type.include?(RDF::URI("http://fedora.info/definitions/v4/repository#Resource"))
  end
end
