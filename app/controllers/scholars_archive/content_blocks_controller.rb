# frozen_string_literal: true

module ScholarsArchive
  class ContentBlocksController < ApplicationController
    def update
      @content_block = ContentBlock.find_by(name: params[:name])
      @content_block.update(value: params[:content_block][:content])
      redirect_to root_path
    end
  end
end