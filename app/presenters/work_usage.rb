# class WorkUsage follows the model established by FileUsage
# Called by the stats controller, it finds cached work pageview data,
# and prepares it for visualization in /app/views/stats/work.html.erb

class WorkUsage
  attr_accessor :id, :created, :pageviews, :work

  def initialize(id)
    @work = CurationConcerns::WorkRelation.new.find(id)
    user = User.find_by(email: work.depositor)
    user_id = user ? user.id : nil

    self.id = id
    self.created = date_for_analytics(work)
    self.pageviews = WorkViewStat.to_flots WorkViewStat.statistics(work, created, user_id)
  end

  delegate :to_s, to: :work

  def total_pageviews
    pageviews.reduce(0) { |total, result| total + result[1].to_i }
  end

  # Package data for visualization using JQuery Flot
  def to_flot
    [
      { label: "Pageviews", data: pageviews }
    ]
  end

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

    # work.date_uploaded reflects the date the work was uploaded by the user
    # and therefore (if available) the date that we want to use for the stats
    # work.create_date reflects the date the work was added to Fedora. On data
    # migrated from one repository to another the created_date can be later
    # than the date the work was uploaded.
    def date_for_analytics(work)
      earliest = Sufia.config.analytic_start_date
      date_uploaded = string_to_date work.date_uploaded
      date_analytics = date_uploaded ? date_uploaded : work.create_date
      return date_analytics if earliest.blank?
      earliest > date_analytics ? earliest : date_analytics
    end

    def string_to_date(date_str)
      return Time.zone.parse(date_str)
    rescue ArgumentError, TypeError
      return nil
    end

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
