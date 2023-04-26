Bolognese::Readers::HyraxWorkReader.module_eval do
  def read_hyrax_work(string: nil, **options)
    read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url, :sandbox, :validate, :ra))

    meta = string.present? ? Maremma.from_json(string) : {}

    {
      # "id" => meta.fetch('id', nil),
      "identifiers" => read_hyrax_work_identifiers(meta),
      "types" => read_hyrax_work_types(meta),
      "datacite_doi" => normalize_doi(meta.fetch('datacite_doi', nil)&.first),
      # "url" => normalize_id(meta.fetch("URL", nil)),
      "titles" => read_hyrax_work_titles(meta),
      "creators" => read_hyrax_work_creators(meta),
      "contributors" => read_hyrax_work_contributors(meta),
      # "container" => container,
      "publisher" => read_hyrax_work_publisher(meta),
      # "related_identifiers" => related_identifiers,
      # "dates" => dates,
      "publication_year" => read_hyrax_work_publication_year(meta),
      "descriptions" => read_hyrax_work_descriptions(meta),
      # "rights_list" => rights_list,
      # "version_info" => meta.fetch("version", nil),
      "subjects" => read_hyrax_work_subjects(meta)
      # "state" => state
    }.merge(read_options)
  end
end