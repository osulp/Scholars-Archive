namespace :scholars_archive do
  desc "Update peer review predicate data from all work graphs & change value to lowercase"
  task update_peer_review_data: :environment do
    # SETUP: Add in the start time of the bulk changes and add message to know that the rake is starting
    datetime_today = Time.now.strftime('%Y%m%d%H%M%S') # "20171021125903"
    Rails.logger.info "Processing bulk changes for peer review"

    # ADD: Add in all the works that are in production to an array
    Rails.logger.info "Finding all the works..."
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

    # SEARCHING: After all the works are added, search for the one that has the old predicate
    Rails.logger.info "All works found. Searching for works to be updated"
    old_predicate = ::RDF::URI.new('http://purl.org/ontology/bibo/peerReviewed')

    # LOOP: Now loop through each works and identify the work that needed to be updated
    all_records.each do |works|
      works.each do |record|
        # FETCH: Get the old peer review from the work
        old_peer_review_statement = [record.resource.rdf_subject, old_predicate, nil]

        # CONDITION: If the peer review section found in work, get the info out for preparing to be delete
        if !record.resource.graph.query(old_peer_review_statement).statements.empty?
          # GET: Get the graph
          orm = Ldp::Orm.new(record.ldp_source)
          new_update_value = orm.query(old_peer_review_statement).first.object.value.downcase
          statement = [orm.resource.subject_uri, old_predicate, nil]

          # DELETE: Delete the graph
          orm.graph.delete(statement)

          # CHECK: Now save the works and update the value to lowercase
          if orm.save
            logger.info "Deleted statement from Fedora: #{statement}"
            logger.info "Setting the value to lowercase"
            record.peerreviewed = new_update_value
            record&.save
          else
            logger.info "Failed to delete statement from Fedora: #{statement}"
          end
        end
      end
    end
  end
end
