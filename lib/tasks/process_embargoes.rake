desc "Remove lapsed embargoes"
task :process_embargoes => :environment do |t|
  items = Hydra::EmbargoService.assets_with_expired_embargoes
  if items.length == 0
    puts "No items need processing at this time"
  else
    items.each do |item|
      item.embargo_visibility!
      item.save!
    end
    puts "processed #{items.length} embargo(es)"
  end
end
