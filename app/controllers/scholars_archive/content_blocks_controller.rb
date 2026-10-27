# frozen_string_literal: true

module ScholarsArchive
  # Controller for updating content blocks for tombstones
  class ContentBlocksController < ApplicationController
    load_and_authorize_resource
    with_themed_layout 'dashboard'

    def update
      @content_block = ContentBlock.find_by(name: params[:name])
      @content_block.update(value: CGI.unescapeHTML(params[:content_block][:content]))
      @work = ActiveFedora::Base.find(@content_block.name.split('-').last)
      redirect_to polymorphic_path(@work)
    end
  end
end
