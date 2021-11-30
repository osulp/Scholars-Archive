namespace :scholars_archive do
  desc "Update conference section preducate data from all work graphs"
  task :update_conference_section_data, [:chunk_size] => :environment do |t, args|
    # Set a default value of 100 for chunk_size
    args.with_defaults(:chunk_size => 100)
    datetime_today = Time.now.strftime('%Y%m%d%H%M%S') # "20171021125903"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/abstract-conference-section-#{datetime_today}.log")
    logger.info "Processing bulk changes for conference section"

    logger.info "finding all works"
    all_records = [::AdministrativeReportOrPublication.all]
    all_records << ::Article.all
    all_records << ::BatchUploadItem.all
    all_records << ::ConferenceProceedingsOrJournal.all
    all_records << ::Dataset.all
    all_records << ::Default.all
    all_records << ::EescPublication.all
    all_records << ::GraduateProject.all
    all_records << ::GraduateThesisOrDissertation.all
    all_records << ::HonorsCollegeThesis.all
    all_records << ::OpenEducationalResource.all
    all_records << ::PurchasedEResource.all
    all_records << ::TechnicalReport.all
    all_records << ::UndergraduateThesisOrProject.all

    logger.info "All works found. Searching for works to be updated"
    to_update = {}
    old_predicate = ::RDF::URI.new('https://w2id.org/scholarlydata/ontology/conference-ontology.owl#Track')

    all_records.each do |works|
      works.each_with_index do |record, index|
        old_conference_section_statement = [record.resource.rdf_subject, old_predicate, nil]

        # If conference section to delete exist
        if !record.resource.graph.query(old_conference_section_statement).statements.empty?
          orm = Ldp::Orm.new(record.ldp_source)
          new_value = orm.query(old_conference_section_statement).first.object.value

          to_update.merge!({ record.id => new_value })
        end
      end
    end
    to_update.each_slice(args.chunk_size) do |params|
      ReplacePredicateJob.perform_later(params, old_predicate.to_s, 'conference_section')
    end
  end
end
