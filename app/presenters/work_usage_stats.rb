# class WorkUsage follows the model established by FileUsage
# Called by the stats controller, it finds cached work pageview data,
# and prepares it for visualization in /app/views/stats/work.html.erb
class WorkUsageStats < WorkUsage
  def date_list_for_monthly_table
    (0..11).reverse_each.map do |months_ago|
      Date.today.months_ago(months_ago).strftime("%b %Y")
    end
  end

  def pageviews_by_month
    table_by_month(pageviews)
  end

  def daily_stats_csv
    data = pageviews.map { |t, p| { Time.at(t / 1000) => p } }
    to_csv(data, ["Year", "Month", "Day", "Pageviews"])
  end

  def monthly_stats_csv
    to_csv(pageviews_by_month, ["Year", "Month", "Pageviews"])
  end

  private

  # helper functions to create the monthly table

  def to_csv(data, header)
    ::CSV.generate do |csv|
      csv << header
      data.each do |item|
        if header.include? 'Day'
          date = item.keys.first.to_datetime
          values = Array([date.year, date.month, date.day, item[item.first.first] || 0])
        else
          date = item.first.to_datetime
          values = Array([date.year, date.month, item.second || 0])
        end
        csv << values
      end
    end
  end

  def table_by_month(data)
    months = converted_data(data)
    months.each_pair { |key, value| months[key] = reduce_analytics_value(value) }
    Hash[default_date_hash].merge(months)
  end

  def converted_data(data)
    data.group_by { |t| Time.at(t.first / 1000).to_datetime.strftime("%b %Y") }
  end

  def reduce_analytics_value(value)
    value.reduce(0) { |total, result| total + result[1].to_i }
  end

  def default_date_hash
    date_list_for_monthly_table.map { |d| [d, 0] }
  end
end
