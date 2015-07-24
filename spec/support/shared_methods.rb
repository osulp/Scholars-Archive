def build_resource(uri:, label:)
  TriplePoweredResource.new(uri).tap do |r|
    r.preflabel = label
    r.persist!
  end
end
