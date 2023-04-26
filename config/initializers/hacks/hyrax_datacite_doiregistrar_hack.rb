# frozen_string_literal:true

Hyrax::DOI::DataCiteRegistrar.class_eval do
  ##
  # @param object [#id]
  #
  # @return [#identifier]
  def register!(object: work)
    # OVERRIDE to use correct datacite_doi property
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

  def public?(work)
    # OVERRIDE to prevent registration until review
    work.visibility == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC && !work.suppressed?
  end

  # Do the heavy lifting of submitting the metadata, registering the url, and ensuring the correct status
  def submit_to_datacite(work, doi)
    # 1. Add metadata to the DOI (or update it)
    # TODO: check that required metadata is present if current DOI record is registered or findable OR handle error?
    client.put_metadata(doi, work_to_datacite_xml(work))

    # OVERRIDE to not set DOI to registered/findable if the work hasn't actually reached public
    # 2. Register a url with the DOI if it should be registered or findable
    client.register_url(doi, work_url(work)) if work.doi_status_when_public.in?(['registered', 'findable']) && public?(work)

    # 3. Always call delete metadata unless findable and public
    # Do this because it has no real effect on the metadata and
    # the put_metadata or register_url above may have made it findable.
    client.delete_metadata(doi) unless work.doi_status_when_public == 'findable' && public?(work)
  end
end