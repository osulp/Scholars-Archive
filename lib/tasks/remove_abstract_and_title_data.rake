namespace :scholars_archive do
  desc "Remve abstract and title data from all graphs"
  task remove_abstract_and_title_data: :environment do
    datetime_today = Time.now.strftime('%Y%m%d%H%M%S') # "20171021125903"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/abstract-title-#{datetime_today}.log")
    logger.info "Processing bulk changes for abstract and title"

    logger.info "finding all works"
    all_records = ActiveFedora::Base.all

    logger.info "All works found. Searching for works to be updated"
    all_records.each do |record|
      title_statement = [record.resource.rdf_subject, RDF::Vocab::DC.title, nil] 
      abstract_statement = [record.resource.rdf_subject, RDF::Vocab::DC.abstract, nil] 

      unless record.resource.graph.query(title_statement).statements.empty?
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
      end

      unless record.resource.graph.query(abstract_statement).statements.empty?
        logger.info ""
        logger.info "Work found #{record.id}. Updating abstract. Pulling graph from fedora"
        orm = Ldp::Orm.new(record.ldp_source)

        logger.info "Deleting abstract"
        orm.graph.delete(abstract_statement)

        logger.info "Saving the graph"
        if orm.save

          logger.info "Graph saved successfully. Setting records abstract to be empty."
          record.title = []

          logger.info "Saving record"
          record.save
        else
          logger.error "Something went wrong with #{record.id}"
        end
      end
    end
  end
end
