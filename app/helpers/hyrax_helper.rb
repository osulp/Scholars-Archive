module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def human_readable_date_edtf(options)
    value = options[:value].first
    date = Date.edtf(value)
    if date.instance_of? EDTF::Interval
      output = date.from.edtf + ' to ' + date.to.edtf
    elsif date.present?
      output = date.edtf
    else
      output = value
    end
    return output
  end

  ##
  # TriplePoweredProperties store their label and uri in SOLR in the format of "label$URI"
  # and the facets listed on the catalog controller need to only display the pertinent label.
  # @param [String] value - the value of the SOLR index field, see catalog_controller
  # @returns [String] - the label split by the $ character
  def parsed_label_uri(value)
    value.split('$').first
  end
end
