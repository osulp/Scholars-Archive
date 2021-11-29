namespace :scholars_archive do
  desc "Update conference section preducate data from all work graphs"
  task update_conference_section_data: :environment do
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
    all_records.each do |works|
      works.each do |record|
        old_conference_section_statement = [record.resource.rdf_subject, ::RDF::URI.new('https://w2id.org/scholarlydata/ontology/conference-ontology.owl#Track'), nil]

        # If conference section to delete exist
        if !record.resource.graph.query(old_conference_section_statement).statements.empty?
          orm = Ldp::Orm.new(record.ldp_source)
          new_value = orm.query(old_conference_section_statement).first.object.value

          logger.info ""
          logger.info "Work found #{record.id}. Updating conference section"

          logger.info "Setting to previous value: #{new_value}"
          record.conference_section = new_value

          logger.info "Saving record"
          if record.save
            logger.info "Work saved. Removing old conference section. Pulling graph from fedora"

            logger.info "Deleting conference section from graph"
            orm.graph.delete(old_conference_section_statement)

            logger.info "Saving the graph"
            if orm.save
              logger.info "Graph saved successfully"
            else
              logger.error "Something went wrong with removing old value from graph #{record.id}"
            end
          else
            logger.error "Something went wrong adding previous value #{record.id}"
          end
        end
      end
    end
  end
end
