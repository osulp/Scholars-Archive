class StatsController < ApplicationController
  include Sufia::Breadcrumbs
  include Sufia::SingularSubresourceController

  before_action :build_breadcrumbs, only: [:work, :file]

  # call app/presenters/work_usage.rb
  def work
    @stats = WorkUsage.new(params[:id])
  end

  def file
    @about_stats_text = ContentBlock.find_or_create_by(name: "about_stats_text")
    @about_stats_table_text = ContentBlock.find_or_create_by(name:"about_stats_table_text" )
    @about_stats_graph_text = ContentBlock.find_or_create_by(name: "about_stats_graph_text")
    @about_stats_overview_text = ContentBlock.find_or_create_by(name: "about_stats_overview_text")
    @stats = FileUsage.new(params[:id])
  end

  # routed to /files/:id/daily_stats
  def daily_stats
    respond_to do |format|
      format.csv { send_data file.daily_stats_csv, filename: "daily_stats_#{params[:id]}.csv" }
    end
  end

  # routed to /files/:id/monthly_stats
  def monthly_stats
    respond_to do |format|
      format.csv { send_data file.monthly_stats_csv, filename: "monthly_stats_#{params[:id]}.csv" }
    end
  end

end
