class DefaultValuesObject
  def initialize(input_object)
    @input_object = input_object
  end

  def set_default_values
    default_values.each_pair do |key, value|
      @input_object[key] = value if @input_object[key].first.empty?
    end
    @input_object
  end

  private

  def default_values
    {
      "publisher" => I18n.t('form_defaults.publisher'),
      "language" => I18n.t('form_defaults.language_uri')
    }
  end
end
