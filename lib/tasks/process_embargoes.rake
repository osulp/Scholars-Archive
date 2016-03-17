desc "Remove lapsed embargoes"
task :process_embargoes => :environment do |t|
  begin
    items = Hydra::EmbargoService.assets_with_expired_embargoes

    config = APPLICATION_CONFIG["notifications"]["embargoes_lifting"]
    subject = config["subject"]
    from = config["from"]
    to = config["to"].split(',')
    error = nil
    if items.length > 0
      items.each do |item|
        item.embargo_visibility!
        item.save!
      end
    end
  rescue Exception => e
    to << ",libtech.support@oregonstate.edu" unless to.empty?
    to = "libtech.support@oregonstate.edu" if to.empty?
    error = "Exception caught while processing: #{e.message}"
  end

  EmbargoesMailer.embargoes_lifted_email(items, from, to, subject, error).deliver_now
end
