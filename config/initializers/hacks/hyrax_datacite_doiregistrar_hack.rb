# frozen_string_literal:true

Hyrax::DOI::DataCiteRegistrar.class_eval do
  ##
  # @param object [#id]
  #
  # @return [#identifier]
  def register!(object: work)
    doi = Array(object.try(:datacite_doi)).first

    # Return the existing DOI or nil if nothing needs to be done
    return Struct.new(:identifier).new(doi) unless register?(object)

    # Create a draft DOI (if necessary)
    doi ||= mint_draft_doi

    # Submit metadata, register url, and ensure proper status
    submit_to_datacite(object, doi)

    # Return the doi (old or new)
    Struct.new(:identifier).new(doi)
  end
end