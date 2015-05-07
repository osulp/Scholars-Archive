# app/presenters/file_presenter.rb
class FilePresenter < Sufia::GenericFilePresenter
  self.terms = [:dc_type, :title, :creator, :contributor, :description,
                :tag, :rights, :publisher, :date, :subject, :language,
                :spatial, :temporal, :abstract, :tableOfContents, :format, 
		:bibliographicCitation, :provenance, :isReferencedBy, :relation,
		:rights, :title, :type, :isCitedBy, :isIdenticalTo, :isPartOf,
		:isVersionOf, :doi, :hdl, :orcid, :rid]
end
