namespace :scholars_archive do
  desc "Update peer review predicate data from all work graphs & change value to lowercase"
  task :update_peer_review_data, [:chunk_size] => :environment do |t, args|
    # SETUP: Add in the start time of the bulk changes and add message to know that the rake is starting
    #        and set a default value of 100 for chunk_size
    args.with_defaults(:chunk_size => 100)
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
    to_update = {}
    old_predicate = ::RDF::URI.new('http://purl.org/ontology/bibo/peerReviewed')

    # LOOP: Now loop through each works and identify the work that needed to be updated
    all_records.each do |works|
      works.each_with_index do |record, index|
        # FETCH: Get the old statement from work that has the old predicate
        old_peer_review_statement = [record.resource.rdf_subject, old_predicate, nil]

        # CONDITION: If conference section to delete exist
        if !record.resource.graph.query(old_peer_review_statement).statements.empty?
          # GET: Setup the graph and change the value to be reflected of the new value
          orm = Ldp::Orm.new(record.ldp_source)
          new_value = orm.query(old_peer_review_statement).first.object.value.downcase

          # ADD: Add the list of updated value to the hash
          to_update.merge!({ record.id => new_value })
        end
      end
    end

    # UPDATE: Now go through each update value to delete the old graph and assign the new value to it
    to_update.each_slice(args.chunk_size.to_i) do |params|
      ReplacePredicateJob.perform_later(params, old_predicate.to_s, 'peerreviewed')
    end
  end
end
