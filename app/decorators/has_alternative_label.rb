class HasAlternativeLabel < SimpleDelegator
  def alternative_labels
    get_values(RDF::SKOS.altLabel)
  end

  class Factory < SimpleDelegator
    def new(*args)
      HasAlternativeLabel.new(super)
    end
  end
end
