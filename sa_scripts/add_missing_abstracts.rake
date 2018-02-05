namespace :scholars_archive do
  desc "Add missing abstracts"
  task :add_missing_abstracts => :environment do
    require 'csv'
    abstract_file = '/data0/hydra/shared/tmp/missing_abstract/output.csv'
    add_missing_abstracts(abstract_file)
  end

  def add_missing_abstracts(abstract_file)

    CSV.foreach(abstract_file, headers: true, header_converters: :symbol) do |row|
      replace = row[:replace]
      abstract = row[:abstract]
      solr_query_str = "has_model_ssim:\"GraduateThesisOrDissertation\" AND replaces_tesim:\"#{replace}\""
      doc = ActiveFedora::SolrService.query(solr_query_str, {:rows => 1}).first

      if doc.nil?
        puts "#{replace} NOT found!"
      else
        puts doc['title_tesim']
        begin
          work_model = doc["has_model_ssim"].first.constantize
          work = work_model.find(doc["id"])
          work.abstract += [abstract]
          if work.save!(validate: true)
            puts "abstract saved for #{doc["id"]}"
          else
            puts "abstract saved failed for #{doc["id"]}"
          end

        rescue => e
          puts "\t error found for #{doc["id"]} #{e.message}"
        end
      end
    end

  end
end
