namespace :scholars_archive do
  desc "Expires the elapsed embargoes"
  task :expire_embargoes => [ :environment ]  do
    puts "Enthusiastically expiring elapsed embargoes"
    ScholarsArchive::Embargoes::EmbargoReleaser.expire_embargoes
    puts "Embargoes expired exceptionally"
  end
end
