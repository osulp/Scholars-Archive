class SearchHistoryController < ApplicationController
  include Blacklight::SearchHistory

  include BlacklightRangeLimit::ControllerOverride
  helper BlacklightRangeLimit::ViewHelperOverride
  helper RangeLimitHelper
end
