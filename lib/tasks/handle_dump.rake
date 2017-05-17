namespace :scholars_archive do
  desc "Dump all handles associated with all objects in db"
  task :handle_dump do
    puts "Beginning building"
    @hash = {}
    response = ActiveFedora::SolrService.get("replaces_tesim:*", :rows => 100000)["response"]["docs"]
    response.each do |work_solr_doc|
      @hash[work_solr_doc["replaces_tesim"].first] = work_solr_doc["id"]
    end
    puts @hash
  end
end
