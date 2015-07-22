class AltLabelEnhancement
  pattr_initialize :raw_property

  def properties
    [SolrProperty.new(solr_identifier, alternative_labels)]
  end

  private

  def alternative_labels
    resources.flat_map(&:alternative_labels)
  end

  def resources
    @resources ||= OnlyUris.new(raw_property.values)
      .map{|x| resource_factory.new(x)}
  end

  def solr_identifier
    raw_property.derivative_properties[:alternative_label].property_key
  end

  def resource_factory
    HasAlternativeLabel::Factory.new(TriplePoweredResource)
  end
end
