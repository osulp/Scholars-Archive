module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Stats".constantize
    presenter = klass.new(object.id)
    yield presenter if block_given?
    presenter
  end

  def present_about_stats_block
    ContentBlock.find_or_create_by(name: "about_stats_text")
  end

  def present_about_stats_table_block
    ContentBlock.find_or_create_by(name:"about_stats_table_text" )
  end

  def present_about_stats_graph_block
    ContentBlock.find_or_create_by(name: "about_stats_graph_text")
  end

  def present_about_stats_overview_block
    ContentBlock.find_or_create_by(name: "about_stats_overview_text")
  end

  def present_about_work_stats_block
    ContentBlock.find_or_create_by(name: "about_work_stats_text")
  end

  def present_about_work_stats_table_block
    ContentBlock.find_or_create_by(name: "about_work_stats_table_text" )
  end

  def present_about_work_stats_graph_block
    ContentBlock.find_or_create_by(name: "about_work_stats_graph_text")
  end

  def present_about_work_stats_overview_block
    ContentBlock.find_or_create_by(name: "about_work_stats_overview_text")
  end
end
