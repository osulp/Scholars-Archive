# frozen_string_literal: true

# saved searches controllers
class SavedSearchesController < ApplicationController
  include Blacklight::SavedSearches
  helper BlacklightAdvancedSearch::RenderConstraintsOverride
end
