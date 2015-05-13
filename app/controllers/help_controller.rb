class HelpController < ApplicationController
  before_filter :validate_page_type

  def page
    @page = content_block(page_name)
  end

  private

  def page_name
    params[:page]
  end

  def validate_page_type
    unless valid_pages.include?(page_name.to_sym)
      raise ActionController::RoutingError.new('Not Found')
      render :status => :not_found
    end
  end

  def valid_pages
    [:general, :faculty, :graduate, :undergraduate]
  end

  def content_block(page)
    ContentBlock.find_or_create_by( :name => "help_#{page}")
  end
end
