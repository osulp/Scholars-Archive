# The Label Enhancement takes URI properties and returns their preferred labels.
# @example LabelEnhancement.new(SolrProperty.new("lcsubject_ssim",
#   [RDF::URI("http://bla.org")]))
class LabelEnhancement
  pattr_initialize :raw_property

  # @return [Array<SolrProperty>] Properties with labels for the property passed to
  # this.
  def properties
    [SolrProperty.new(solr_identifier, values)]
  end

  private

  def values
    OnlyUris.new(raw_property.values).map do |value|
      NotBlank.new(resource(value).preferred_label).value
    end.compact
  end

  def solr_identifier
    raw_property.derivative_properties[:preferred_label].property_key
  end

  def resource(value)
    TriplePoweredResource.new(value)
  end
end
