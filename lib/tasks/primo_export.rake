# frozen_string_literal: true

namespace :scholars_archive do
  desc 'Generate primo recommender export'
  task :primo_export do
    puts 'Exporting SA works for primo recommender'
    require 'csv'
    docs = ActiveFedora::SolrService.query('has_model_ssim:* AND -has_model_ssim:FileSet AND -has_model_ssim:Hydra* AND -has_model_ssim:ActiveFedora* AND -has_model_ssim:AdminSet', rows: 100_000, fl: 'has_model_ssim,id,title_tesim')
    CSV.open('/data0/hydra/shared/primo-recommender-ouput.csv', 'w') do |csv|
      csv << %w[key name tags description image_url url url_text internal_note]
      docs.each do |doc|
        csv << ['', doc['title_tesim'].first.to_s, '', '', '', "https://ir.library.oregonstate.edu/concern/#{doc['has_model_ssim'].first.pluralize.underscore}/#{doc['id']}", '', '']
      end
    end
    puts 'Done.'
  end
end
