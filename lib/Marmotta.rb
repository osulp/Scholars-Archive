class Marmotta
  def initialize
    @marmotta ||= MarmottaConnection.new(uri: "http://localhost:8983/marmotta", context: Rails.env)
  end

  def new (uri) 
    @marmotta ||= MarmottaConnection.new(uri: uri, context: Rails.env)
  end
end
