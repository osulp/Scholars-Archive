# frozen_string_literal: true

namespace :scholars_archive do
  desc 'Generate primo recommender export'
  task :convert_creators do
    require 'csv'

    # Iterate over csv first for migrated works
    CSV.foreach('/data0/hydra/shared/creator_data.csv', :headers => true) do |row|#Pull data from file
      # Set work and handle as empty string unless it is already assigned with something
      work ||= ""
      handle ||= ""

      # Check if we are on a new work or the first work
      unless handle.blank? || handle == row["handle"]
        #If we are on a new work and it isnt the first row, then check the previous work and see if the creators are the same length and the new creators
        unless work.creators.length == work.nested_ordered_creators.length
          # Report that the amount of creators is different than the amount of nested_ordered_creators
        end
      end

      # Pull solr doc of current handle
      doc = ActiveFedora::SolrService.query("handle_tesim:#{row["handle"]}")

      # Query for object in database.
      work = ActiveFedora::Base.find(doc["id"])

      # Check if the works creators contains the current name
      if !work.creators.include?(row["text_value"])
        # Report miss match
      end

      # Add the current name and place as a nested ordered creator to the work.
      work.nested_ordered_creators << NestedOrderedCreator.create(creator:row["text_value"], index: row["place"] - 1) 

    end

    # Query solr for all docs without handles
    docs = ActiveFedora::SolrService.query("-handle_tesim:*")

    # Iterate over all docs
    docs.each do |doc|

      # Find work based on ID
      work = ActiveFedora::Base.find(doc["id"]) 

      # Iterate over the creators
      work.creators.each_with_index do |creator, i|

        # Translate creators over to nested ordered creators
        work.nested_ordered_creators << NestedOrderedCreator.create(creator: creator, index: i)
      end
    end
  end
end


def data_to_hash(data)

end