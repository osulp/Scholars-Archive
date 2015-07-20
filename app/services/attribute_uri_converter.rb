class AttributeURIConverter
  def initialize(attributes)
    @attributes = attributes.dup
  end

  def convert_attributes
    @attributes.each do |property, value|
      convert_attribute(property, value)
    end

    @attributes
  end

  private

  def convert_attribute(property, value)
    if Array === value
      convert_attribute_list(property, value)
    else
      @attributes[property] = to_uri(value)
    end
  end

  def convert_attribute_list(property, values)
    unless blacklisted_properties.include?(property)
      @attributes[property] = values.map {|v| to_uri(v)}
    end
  end

  def to_uri(v)
    MaybeURI.new(v).value
  end

  def blacklisted_properties
   [
     "rights"
   ]
  end
end
