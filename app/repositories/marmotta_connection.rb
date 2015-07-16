class MarmottaConnection
  attr_reader :uri, :context
  def initialize(uri:, context:nil)
    @uri = uri
    @context = context
  end

  def delete_all
    contexts.each do |context|
      connection.delete("context/#{context}")
    end
  end

  def contexts
    Array(context || "default")
  end

  def connection
    @connection ||= Hurley::Client.new(uri).tap do |c|
      c.header[:accept] = mime_type
      c.header[:content_type] = mime_type
    end
  end

  def resource_connection
    @resource_connection ||= Hurley::Client.new("#{uri}/resource").tap do |c|
      c.header[:accept] = mime_type
      c.header[:content_type] = mime_type
    end
  end

  def context_connection
    @context_connection ||= Hurley::Client.new("#{uri}/context").tap do |c|
      c.header[:accept] = mime_type
      c.header[:content_type] = mime_type
      c.query[:graph] = "#{uri}/context/#{context}"
    end
  end

  private

  def mime_type
    "application/ld+json"
  end
end
