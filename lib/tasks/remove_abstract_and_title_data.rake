namespace :scholars_archive do
  desc "Remove abstract and title data from all work graphs"
  task remove_abstract_and_title_data: :environment do
    datetime_today = Time.now.strftime('%Y%m%d%H%M%S') # "20171021125903"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/abstract-title-#{datetime_today}.log")
    logger.info "Processing bulk changes for abstract and title"

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
    all_records.each do |works|
      works.each do |record|
        title_statement = [record.resource.rdf_subject, RDF::Vocab::DC.title, nil]
        nested_title_statement = [record.resource.rdf_subject, RDF::Vocab::DC11.title, nil]
        abstract_statement = [record.resource.rdf_subject, RDF::Vocab::DC.abstract, nil]
        nested_abstract_statement = [record.resource.rdf_subject, RDF::Vocab::BIBO.abstract, nil]

        # if unordered title to delete exist AND ordered title to fall back on exist
        if !record.resource.graph.query(title_statement).statements.empty? && !record.resource.graph.query(nested_title_statement).statements.empty?
          logger.info ""
          logger.info "Work found #{record.id}. Updating title. Pulling graph from fedora"
          orm = Ldp::Orm.new(record.ldp_source)

          logger.info "Deleting title from graph"
          orm.graph.delete(title_statement)

          logger.info "Saving the graph"
          if orm.save

            logger.info "Graph saved successfully. Setting records title to be empty."
            record.title = []

            logger.info "Saving record"
            record.save
          else
            logger.error "Something went wrong with #{record.id}"
          end
        # If unordered title to delete exist BUT there were no ordered titles
        elsif !record.resource.graph.query(title_statement).statements.empty? && record.resource.graph.query(nested_title_statement).statements.empty?
          logger.error "Skipping work #{record.id} because of missing ordered title data"
          logger.error "#{record.id}: #{record.resource.graph.query(title_statement).statements.count} titles found"
          logger.error "#{record.id}: #{record.resource.graph.query(nested_title_statement).statements.count} ordered titles found"
        end

        # If unordered abstracts to delete exist AND ordered abstracts to fall back on exist
        if !record.resource.graph.query(abstract_statement).statements.empty? && !record.resource.graph.query(nested_abstract_statement).statements.empty?
          logger.info ""
          logger.info "Work found #{record.id}. Updating abstract. Pulling graph from fedora"
          orm = Ldp::Orm.new(record.ldp_source)

          logger.info "Deleting abstract"
          orm.graph.delete(abstract_statement)

          logger.info "Saving the graph"
          if orm.save

            logger.info "Graph saved successfully. Setting records abstract to be empty."
            record.abstract = []

            logger.info "Saving record"
            record.save
          else
            logger.error "Something went wrong with #{record.id}"
          end
        # If unordered abstracts to delete exist BUT there were no ordered abstracts
        elsif !record.resource.graph.query(abstract_statement).statements.empty? && record.resource.graph.query(nested_abstract_statement).statements.empty?
          logger.error "Skipping work #{record.id} because of missing abstract data"
          logger.error "#{record.id}: #{record.resource.graph.query(abstract_statement).statements.count} abstracts found"
          logger.error "#{record.id}: #{record.resource.graph.query(nested_abstract_statement).statements.count} ordered abstracts found"
        end
      end
    end
  end
end
