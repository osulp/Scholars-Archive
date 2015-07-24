module ScholarsArchive
  def marmotta
    @marmotta ||= Marmotta::Connection.new(uri: Settings.marmotta.url, context: Rails.env)
  end

  module_function :marmotta
end
