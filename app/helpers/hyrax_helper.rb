# frozen_string_literal: true

# hyrax helper
module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior
  include ScholarsArchive::CitationsBehavior

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

  def parsed_index(value)
    value.split('$').first
  end

  def truncated_summary(options)
    value = options[:value].first
    value.truncate_words(50)
  end

  # Diacritic sortable facets are all downcase but need to be humanized names
  # Titleize comes close, but some words need to be downcased again
  def diacritic_facet_denorm_affixes(value)
    # Create a list of words to always be lowercase
    # Some more affixes could be added from here:
    #   https://en.wikipedia.org/wiki/List_of_family_name_affixes
    force_lower = %w[de la jr jr. du del della d' van\ der von van]
    # Capitalize the first letter of each word
    value = value.titleize
    # Downcase words in our list
    force_lower.each { |w| value.gsub!(/\b#{w.titleize}\b/, w.downcase) }
    value
  end
end
