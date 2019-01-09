# frozen_string_literal: true

# search history controller
class SearchHistoryController < ApplicationController
  include Blacklight::SearchHistory
  include BlacklightRangeLimit::ControllerOverride
  helper BlacklightRangeLimit::ViewHelperOverride
  helper RangeLimitHelper
  helper BlacklightAdvancedSearch::RenderConstraintsOverride
end
