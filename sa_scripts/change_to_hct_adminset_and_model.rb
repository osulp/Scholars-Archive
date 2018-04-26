# Change AdminSet and Model via RDF update of works with SPARQL
# Need to run locally with SSH Tunneling to Production, or on Production directly
# If Console is local, logs will be local, may want to upload to Production when done
# The SPARQL update is performed per item, directly to Fedora
# Work ids are just in a text file, each one on new line
# After this is complete, each item needs reindexed in Solr, I did Console on Production

# Rails Console (local):

datetime_today = DateTime.now.strftime('%Y-%m-%d_%H-%M-%p') # "2017-10-27_12-59-PM"
logger = ActiveSupport::Logger.new("#{Rails.root}/log/change_to_hct_adminset_and_model-#{datetime_today}.log")

counter = 0
File.readlines('change_to_hct_adminset_and_model_ids.txt').each do |id|
begin
  puts id

  pairtree_id = id[0..7].split('').each_slice(2).map(&:join).join('/') + '/' + id
  fedora_item_path = "http://localhost:8084/fcrepo/rest/prod/" + pairtree_id

  puts fedora_item_path

  cmd_success = system("curl -X PATCH -H 'Content-Type: application/sparql-update' --data-binary '@change_to_hct_adminset_and_model.rdf' #{fedora_item_path}")

  counter += 1
  logger.info "Changed to HCT AdminSet and Model for work #{id}"
rescue => e
  logger.error "\tFailed to change to HCT AdminSet or Model for work #{id}: #{e.message}"
end

sleep 2

end

logger.info "Done. Changed a total of #{counter} works."
