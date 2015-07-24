RSpec.configure do |config|
  config.before(:each) do
    ScholarsArchive.marmotta.delete_all
  end
end
