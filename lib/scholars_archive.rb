module ScholarsArchive
  def marmotta
    @marmotta ||= Marmotta::Connection.new(uri: marmotta_url, context: Rails.env)
  end

  def marmotta_url
    "http://localhost:8983/marmotta"
  end
  module_function :marmotta
  module_function :marmotta_url
end
