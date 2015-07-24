##
# A solr document with enrichments run against URI-based fields.
class EnrichedSolrDocument
  pattr_initialize :solr_document
  def update_document
    @update_document ||= properties.each_with_object({}) do |property, hsh|
      enhancements.new(property).properties.each do |enhance_property|
        hsh[enhance_property.property_key] ||= []
        hsh[enhance_property.property_key] |= enhance_property.values
      end
    end.delete_if{|_, v| v.blank?}
  end

  # @return An atomic update-ready solr document.
  def to_solr
    @to_solr ||= {"id" => solr_document["id"]}.merge(
    update_document.each_with_object({}) do |(k, v), hsh|
      hsh[k] = {"set" => v}
    end)
  end

  private

  def enhancements
    CompositeEnhancementFactory.new(LabelEnhancement, AltLabelEnhancement)
  end

  def properties
    @properties ||= solr_document.map{|keys| SolrProperty.new(*keys)}
  end
end
