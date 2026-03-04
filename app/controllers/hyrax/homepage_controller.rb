# frozen_string_literal: true
class Hyrax::HomepageController < ApplicationController
  # Adds Hydra behaviors into the application controller
  include Blacklight::SearchContext
  include Blacklight::SearchHelper
  include Blacklight::AccessControls::Catalog

  class_attribute :presenter_class
  self.presenter_class = Hyrax::HomepagePresenter
  layout 'homepage'
  helper Hyrax::ContentBlockHelper

  def index
    @presenter = presenter_class.new(current_ability, collections)
    @featured_researcher = ContentBlock.for(:researcher)
    @marketing_text = ContentBlock.for(:marketing)
    @featured_work_list = FeaturedWorkList.new
    @announcement_text = ContentBlock.for(:announcement)
    recent
  end

  # OVERRIDE: from hyrax
  # Add a method to get the most recent documents by model
  def recent_by_model(model: '', rows: 10)
    # grab recent documents
    (_, docs) = search_service.search_results do |builder|
      builder.rows(rows)
      builder.merge(
        sort: sort_field,
        qf: ["has_model_ssim:#{model}"])
    end
    docs
  rescue Blacklight::Exceptions::ECONNREFUSED, Blacklight::Exceptions::InvalidRequest
    []
  end

  private

  # Return 5 collections
  def collections(rows: 5)
    Hyrax::CollectionsService.new(self).search_results do |builder|
      builder.rows(rows)
    end
  rescue Blacklight::Exceptions::ECONNREFUSED, Blacklight::Exceptions::InvalidRequest
    []
  end

  def recent
    # grab any recent documents
    (_, @recent_documents) = search_service.search_results do |builder|
      builder.rows(4)
      builder.merge(sort: sort_field)
    end
  rescue Blacklight::Exceptions::ECONNREFUSED, Blacklight::Exceptions::InvalidRequest
    @recent_documents = []
  end

  def search_service
    Hyrax::SearchService.new(config: blacklight_config, user_params: { q: '' }, scope: self, search_builder_class: Hyrax::HomepageSearchBuilder)
  end

  def sort_field
    "date_uploaded_dtsi desc"
  end
end
