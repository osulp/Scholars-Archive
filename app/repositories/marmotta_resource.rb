class MarmottaResource
  delegate :context_connection, :to => :connection
  attr_reader :uri, :connection
  def initialize(uri, connection:)
    @uri = uri
    @connection = connection
  end

  def get
    result = resource_connection.get("")
    graph = RDF::Graph.new
    if result.success?
      graph << JSON::LD::Reader.new(result.body)
    end
    graph
  end

  def delete
    resource_connection.delete("").success?
  end

  def post(graph)
    context_connection.post("") do |req|
      req.body = graph.dump(:jsonld)
    end.success?
  end

  private

  def resource_connection
    @resource_connection ||= connection.resource_connection.tap do |c|
      c.query[:uri] = uri.to_s
    end
  end

end
