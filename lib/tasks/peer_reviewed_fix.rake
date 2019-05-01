# frozen_string_literal:true

require 'csv'
STDOUT.sync = true

##
namespace :scholars_archive do
  desc "Bulk change peerreviewed property predicate and value"
  task peer_reviewed_fix: :environment do
    csv_file = ENV['csv']
    process_csv(csv_file)
  end
end

def process_csv(path)
  # Create logger
  datetime_today = Time.now.strftime('%Y%m%d%H%M%S') # "20171021125903"
  logger = ActiveSupport::Logger.new("#{Rails.root}/log/peer_reviewed-#{datetime_today}.log")
  logger.info "Processing bulk change for peerreviewed in csv: #{path}"

  old_predicate = RDF::URI('http://purl.org/ontology/bibo/peerReviewed')
  csv = CSV.table(path, converters: nil)
  csv.each do |row|
    update_work(logger, row, old_predicate)
  end
end

def update_work(logger, row, remove_predicate)
  work = ActiveFedora::Base.find(row[:id].to_s.delete("'"))
  orm = Ldp::Orm.new(work.ldp_source)
  statement = [orm.resource.subject_uri, remove_predicate, nil]
  orm.graph.delete(statement)
  if orm.save
    logger.info "Deleted statement from Fedora: #{statement}"
    logger.info "Setting #{work.id}.peerreviewed to #{row[:value].to_s.downcase}"
    work.peerreviewed = row[:value].to_s.downcase
    work&.save
  else
    logger.info "Failed to delete statement from Fedora: #{statement}"
  end
end
