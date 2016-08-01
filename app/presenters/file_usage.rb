class FileUsage
  attr_accessor :id, :created, :downloads, :pageviews

  def initialize(id)
    file = ::FileSet.find(id)
    user = User.find_by(email: file.depositor)
    user_id = user ? user.id : nil

    self.id = id
    self.created = date_for_analytics(file)
    self.downloads = FileDownloadStat.to_flots FileDownloadStat.statistics(file, created, user_id)
    self.pageviews = FileViewStat.to_flots FileViewStat.statistics(file, created, user_id)
  end

  # file.date_uploaded reflects the date the file was uploaded by the user
  # and therefore (if available) the date that we want to use for the stats
  # file.create_date reflects the date the file was added to Fedora. On data
  # migrated from one repository to another the created_date can be later
  # than the date the file was uploaded.
  def date_for_analytics(file)
    earliest = Sufia.config.analytic_start_date
    date_uploaded = string_to_date file.date_uploaded
    date_analytics = date_uploaded ? date_uploaded : file.create_date
    return date_analytics if earliest.blank?
    earliest > date_analytics ? earliest : date_analytics
  end

  def date_list_for_monthly_table
    (0..11).reverse_each.map do |months_ago|
      Date.today.months_ago(months_ago).strftime("%B %Y")
    end
  end

  def string_to_date(date_str)
    return Time.zone.parse(date_str)
  rescue ArgumentError, TypeError
    return nil
  end

  def downloads_by_month
    table_by_month(downloads)
  end

  def pageviews_by_month
    table_by_month(pageviews)
  end
  

  def total_downloads
    reduce_analytics_value(downloads)
  end

  def total_pageviews
    reduce_analytics_value(pageviews)
  end

  def daily_stats()
    d = downloads.map { |i| Hash[*i] }
    p = pageviews.map { |i| Hash[*i] }
    daily_downloads = d.map { |h| h.map { |k,v| { k => { downloads: v} } } }.flatten
    daily_pageviews = p.map { |h| h.map { |k,v| { k => { pageviews: v} } } }.flatten
    daily_stats = [daily_downloads, daily_pageviews].flatten.inject({}) { |h,v| h[v.keys.first]||=[]; h[v.keys.first] << v.values; h }
    daily_stats_clean = daily_stats.map { |m| {m.first => m.last.flatten.inject(:merge)}}
    to_csv(daily_stats_clean)
  end

  def to_csv(data)
    ::CSV.generate do |csv|
      csv << Array("This file was generated on #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")} and represents statistics for the item at #{path}")
      csv << ["Year", "Month", "Day", "Pageviews", "Downloads"]
      data.each do |item|
        date = Time.at(item.first.first/1000).to_datetime
        values = Array([date.year, date.month, date.day, item[item.first.first][:pageviews] || 0, item[item.first.first][:downloads] || 0])
        csv << values
      end
    end
  end

  def monthly_stats_csv(separator = '|')
    ::CSV.generate do |csv|
      csv << ["Month", "Pageviews", "Downloads"]
      # TODO: Work in progress
      # download_months = downloads.group_by { |t| Time.at(t.first/1000).to_datetime.at_beginning_of_month.strftime("%Y-%m") }
      # download_months.each_pair { |key, value| download_months[key] = value.reduce(0) { |total, result| total + result[1].to_i }} 
      # pageview_months = pageviews.group_by { |t| Time.at(t.first/1000).to_datetime.at_beginning_of_month.strftime("%Y-%m") }
      # pageview_months.each_pair { |key, value| pageview_months[key] = value.reduce(0) { |total, result| total + result[1].to_i }} 
    end
  end

  # Package data for visualization using JQuery Flot
  def to_flot
    [
      { label: "Pageviews",  data: pageviews },
      { label: "Downloads",  data: downloads }
    ]
  end

  def table_by_month(data)
    months = converted_data(data)
    months.each_pair { |key, value| months[key] = reduce_analytics_value(value) }
    Hash[default_date_hash].merge(months)
  end

    def default_date_hash
      date_list_for_monthly_table.map { |d| [d, 0] }
    end

    def converted_data(data)
      data.group_by { |t| Time.at(t.first / 1000).to_datetime.strftime("%B %Y") }
    end

    def reduce_analytics_value(value)
      value.reduce(0) { |total, result| total + result[1].to_i }
    end



end
