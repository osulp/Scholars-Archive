##
# Represents a solr property in a solr document. Has a property_key and values
# associated with it.
class SolrProperty < Struct.new(:property_key, :values)
  attr_reader :property_key, :values
  def initialize(property_key, values=[])
    @property_key = property_key.to_s
    @values = Array.wrap(values)
  end

  def key
    split_key.first
  end

  def solr_identifier
    split_key.last
  end

  def eql?(other_property)
    other_property.try(:property_key) == property_key && other_property.try(:values) == values
  end

  def derivative_properties
    {
      :preferred_label => derivative_key("preferred_label"),
      :alternative_label => derivative_key("alternative_label")
    }
  end

  private

  def derivative_key(derivative)
    self.class.new([key, derivative, solr_identifier].join("_"), [])
  end

  def split_key
    @split_key ||= property_key.rpartition("_")
  end
end

