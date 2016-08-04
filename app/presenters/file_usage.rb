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
      Date.today.months_ago(months_ago).strftime("%b %Y")
    end
  end

  def string_to_date(date_str)
    return Time.zone.parse(date_str)
  rescue ArgumentError, TypeError
    return nil
  end

  def total_downloads
    reduce_analytics_value(downloads)
  end

  def total_pageviews
    reduce_analytics_value(pageviews)
  end

  def downloads_by_month
    table_by_month(downloads)
  end

  def pageviews_by_month
    table_by_month(pageviews)
  end

  def daily_stats_csv
    sort_daily_stats = daily_stats.sort_by { |k, _v| Time.at(k / 1000).to_datetime }
    data = sort_daily_stats.map { |m| { Time.at(m.first / 1000) => m.last.flatten.inject(:merge) } }
    to_csv(data, ["Year", "Month", "Day", "Pageviews", "Downloads"])
  end

  def monthly_stats_csv
    sort_monthly_stats = monthly_stats.sort_by { |k, _v| k.to_date }.map { |m| { m.first => m.last.flatten.inject(:merge) } }
    to_csv(sort_monthly_stats, ["Year", "Month", "Pageviews", "Downloads"])
  end

  # Package data for visualization using JQuery Flot
  def to_flot
    [
      { label: "Pageviews",  data: pageviews },
      { label: "Downloads",  data: downloads }
    ]
  end

  private

    def to_csv(data, header)
      ::CSV.generate do |csv|
        csv << header
        data.each do |item|
          date = item.keys.first.to_datetime
          if header.include? 'Day'
            values = Array([date.year, date.month, date.day, item[item.first.first][:pageviews] || 0, item[item.first.first][:downloads] || 0])
          else
            values = Array([date.year, date.month, item[item.first.first][:pageviews] || 0, item[item.first.first][:downloads] || 0])
          end
          csv << values
        end
      end
    end

    def daily_stats
      daily_download_stats = stats_hash(downloads).map { |h| h.map { |k, v| { k => { downloads: v } } } }.flatten
      daily_pageview_stats = stats_hash(pageviews).map { |h| h.map { |k, v| { k => { pageviews: v } } } }.flatten
      combine_stats(daily_download_stats, daily_pageview_stats)
    end

    def monthly_stats
      monthly_download_stats = stats_hash(downloads_by_month.to_a).map { |h| h.map { |k, v| { k => { downloads: v } } } }.flatten
      monthly_pageview_stats = stats_hash(pageviews_by_month.to_a).map { |h| h.map { |k, v| { k => { pageviews: v } } } }.flatten
      combine_stats(monthly_download_stats, monthly_pageview_stats)
    end

    def combine_stats(a, b)
      [a, b].flatten.each_with_object({}) do |v, h|
        (h[v.keys.first] ||= []) << v.values
      end
    end

    def stats_hash(data)
      data.map { |i| Hash[*i] }
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
      data.group_by { |t| Time.at(t.first / 1000).to_datetime.strftime("%b %Y") }
    end

    def reduce_analytics_value(value)
      value.reduce(0) { |total, result| total + result[1].to_i }
    end

end
