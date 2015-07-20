class TriplePoweredResource < ActiveTriples::Resource
  property :preflabel, :predicate => RDF::SKOS.prefLabel
  def repository
    @repository ||= MarmottaRepository.new(rdf_subject)
  end
end
