# frozen_string_literal: true

class SearchHistoryController < ApplicationController
  include Blacklight::SearchHistory
  include BlacklightRangeLimit::ControllerOverride
  helper BlacklightRangeLimit::ViewHelperOverride
  helper RangeLimitHelper
  helper BlacklightAdvancedSearch::RenderConstraintsOverride
end
