# frozen_string_literal: true

# OVERRIDE: Add in this file to create a custom path to display icon for external resource
module Hyrax::FileSetHelper
  ##
  # @todo inline the "workflow restriction" into the `can?(:download)` check.
  #
  # @param file_set [#id]
  #
  # @return [Boolean] whether to display the download link for the given file
  #   set
  def display_media_download_link?(file_set:)
    Hyrax.config.display_media_download_link? &&
      can?(:download, file_set) &&
      !workflow_restriction?(file_set.try(:parent))
  end

  def parent_path(parent)
    if parent.is_a?(::Collection)
      main_app.collection_path(parent)
    else
      polymorphic_path([main_app, parent])
    end
  end

  ##
  # @deprecated use render(media_display_partial(file_set), file_set: file_set)
  #   instead
  #
  # @param presenter [Object]
  # @param locals [Hash{Symbol => Object}]
  def media_display(presenter, locals = {})
    Deprecation.warn('the helper `media_display` renders a partial name ' \
                     'provided by `media_display_partial`. Callers ' \
                     "should render `media_display_partial(file_set) directly
                     instead.")

    render(media_display_partial(presenter), locals.merge(file_set: presenter))
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Style/StringConcatenation
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  # MODIFY: Add in the 'ext_relation' keyword to the display
  def media_display_partial(file_set)
    'hyrax/file_sets/media_display/' +
      if !file_set.ext_relation.blank? || !curation_concern.ext_relation.blank?
        'ext_relation'
      elsif file_set.image?
        'image'
      elsif file_set.video?
        'video'
      elsif file_set.audio?
        'audio'
      elsif file_set.pdf?
        'pdf'
      elsif file_set.office_document?
        'office_document'
      else
        'default'
      end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Style/StringConcatenation
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity
end
