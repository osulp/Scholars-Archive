require 'csv'

namespace :scholars_archive do
  desc "Clean up the community/collection metadata"
  task collection_community_cleanup: :environment do
    csv_path = '/data0/hydra/shared/tmp/dspace_community_collections.csv'
    json_path = '/data0/hydra/shared/tmp/handles-communities-collections.json'
    collections_path = '/data0/hydra/shared/tmp/collectionlist.csv'
    process(csv_path, json_path, collections_path)
  end
end

def get_collection_rows(path)
  path = File.join(path)
  CSV.read(path, headers: true)
end

def get_handle_rows(path)
  path = File.join(path)
  csv = CSV.read(path, headers: true)
  csv.group_by { |r| r[0] }
end

def get_handle_communities(rows)
  rows.map { |r| r[1] }.uniq
end

def get_handle_collections(rows)
  rows.map { |r| r[2] }.uniq
end

def get_json_data(path)
  path = File.join(path)
  json = JSON.parse(File.read(path))
  json['response']['docs'].group_by { |r| r['replaces_tesim'][0].gsub('http://hdl.handle.net/', '') }
end

def get_json_communities(json, handle)
  return [] unless json.key?(handle) && !json[handle][0]['dspace_community_tesim'].nil?
  json[handle][0]['dspace_community_tesim'].uniq
end

def get_json_collections(json, handle)
  return [] unless json.key?(handle) && !json[handle][0]['dspace_collection_tesim'].nil?
  json[handle][0]['dspace_collection_tesim'].uniq
end

def process(csv_path, json_path, collections_path)
  logger = ActiveSupport::Logger.new("#{Rails.root}/log/sa-community.log")
  collections = get_collection_rows(collections_path)
  handles = get_handle_rows(csv_path)
  solr = get_json_data(json_path)
  puts solr.count
  puts handles.count
  puts collections.count
  handles.each_pair do |k,v|
    puts "processing:#{solr[k]}"
    next if solr[k].nil?
    puts k
    work_id = solr[k][0]['id']
    handle_communities = get_handle_communities(v)
    handle_collections = get_handle_collections(v)
    if handle_communities.any?(&:nil?)
      handle_communities << collections.select {|c| handle_collections.include?(c['collection_name']) }.map {|c| c['community_name'] }
      handle_communities = handle_communities.flatten.uniq.reject(&:nil?)
    end
    solr_communities = get_json_communities(solr, k)
    solr_collections = get_json_collections(solr, k)
    solr_missing_communities = handle_communities - solr_communities
    solr_missing_collections = handle_collections - solr_collections
    next if solr_missing_collections.empty? && solr_missing_communities.empty?
    work = ActiveFedora::Base.find(work_id)
    solr_missing_collections.each do |s|
      work.dspace_collection += [s]
    end
    solr_missing_communities.each do |s|
      work.dspace_community += [s]
    end
    work.save
    work.update_index
    logger.info "updated #{work.id} - #{k}"
  end
end
