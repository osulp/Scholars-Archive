namespace :scholars_archive do
  desc "Remve abstract and title data from all graphs"
  task remove_abstract_and_title_data: :environment do
    all_records = ActiveFedora::Base.all
    all_records.each do |record|
      next if record.resource.graph.query([record.resource.rdf_subject, RDF::Vocab::DC.title, nil]).statements.empty?

      orm = Ldp::Orm.new(record.ldp_source)
      orm.graph.delete([record.rdf_subject, RDF::Vocab::DC.title, nil])
      orm.save
    end
  end
end
