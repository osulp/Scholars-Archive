namespace :scholars_archive do
  desc "Get works with handles where creator has 10 or more items"
  task :migrated_works_10_or_more_creator => :environment do
    custom_query_and_process_csv('creator_tesim', 'migrated_works_10_or_more_creator.csv')
  end

  desc "Get works with handles where title has 10 or more items"
  task :migrated_works_10_or_more_title => :environment do
    custom_query_and_process_csv('title_tesim', 'migrated_works_10_or_more_title.csv')
  end

  desc "Get works with handles where related items has a 10 or more items"
  task :migrated_works_10_or_more_related_items => :environment do
    custom_query_and_process_csv('nested_related_items_tesim', 'migrated_works_10_or_more_related_items.csv')
  end

  desc "Get works with handles where additional info has a 10 or more items"
  task :migrated_works_10_or_more_info => :environment do
    custom_query_and_process_csv('nested_ordered_additional_information_tesim', 'migrated_works_10_or_more_info.csv')
  end

  desc "Get works with handles where contributor has a 10 or more items"
  task :migrated_works_10_or_more_contributor => :environment do
    custom_query_and_process_csv('nested_ordered_contributor_tesim', 'migrated_works_10_or_more_contributor.csv')
  end

  desc "Get works with handles where abstract has a 10 or more items"
  task :migrated_works_10_or_more_abstract => :environment do
    custom_query_and_process_csv('nested_ordered_abstract_tesim', 'migrated_works_10_or_more_abstract.csv')
  end

  def custom_query_and_process_csv(field, csv_name)
    require 'csv'
    query = "#{field}:[* TO *] AND -has_model_ssim:FileSet AND replaces_tesim:[* TO *]"
    response = ActiveFedora::SolrService.query(query, fl: "id,#{field},has_model_ssim", rows: 60000)
    results = response.select { |w| w[field].count > 9 }

    output_path = File.join(Rails.root, 'tmp', csv_name)

    CSV.open(output_path, 'w') do |csv|
      csv << ['id','has_model_ssim',"#{field}_count"]
      results.each do |work|
        csv << [work["id"], work["has_model_ssim"].first.underscore, work[field].count]
      end
    end
  end
end
