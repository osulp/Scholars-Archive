namespace :scholars_archive do
  desc "Enqueue a job to resolrize the repository objects"
  task reindex_by_model: :environment do
    admin_set_map = YAML.load(File.read('config/admin_set_map.yml'))

    admin_set_map.each do |model, _desc|
      ReindexModelJob.perform_later(model)
    end
  end
end