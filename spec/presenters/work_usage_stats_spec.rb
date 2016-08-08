require 'spec_helper'
require 'rails_helper'

describe WorkUsageStats, type: :model do
  let!(:work) do
    GenericWork.new do |work|
      work.title = ["Jill's Research"]
      (1..25).each do |i|
        work.keyword << ["keyword#{format('%02d', i)}"]
      end
      work.apply_depositor_metadata('jilluser')
      work.read_groups = ['public']
      work.save!
    end
  end

  let(:dates) {
    ldates = []
    4.downto(0) { |idx| ldates << (Time.zone.today - idx.day) }
    ldates
  }
  let(:date_strs) {
    ldate_strs = []
    dates.each { |date| ldate_strs << date.strftime("%Y%m%d") }
    ldate_strs
  }

  let(:view_output) {
    [[statistic_date(dates[0]), 4], [statistic_date(dates[1]), 8], [statistic_date(dates[2]), 6], [statistic_date(dates[3]), 10], [statistic_date(dates[4]), 2]]
  }

  # This is what the data looks like that's returned from Google Analytics (GA) via the Legato gem
  # Due to the nature of querying GA, testing this data in an automated fashion is problematc.
  # Sample data structures were created by sending real events to GA from a test instance of
  # Scholarsphere.  The data below are essentially a "cut and paste" from the output of query
  # results from the Legato gem.

  let(:sample_pageview_statistics) {
    [
      OpenStruct.new(date: date_strs[0], pageviews: 4),
      OpenStruct.new(date: date_strs[1], pageviews: 8),
      OpenStruct.new(date: date_strs[2], pageviews: 6),
      OpenStruct.new(date: date_strs[3], pageviews: 10),
      OpenStruct.new(date: date_strs[4], pageviews: 2)
    ]
  }

  let(:usage) {
    allow_any_instance_of(GenericWork).to receive(:create_date).and_return((Time.zone.today - 4.days).to_s)
    expect(WorkViewStat).to receive(:ga_statistics).and_return(sample_pageview_statistics)
    described_class.new(work.id)
  }

  describe "statistics" do
    let!(:system_timezone) { ENV['TZ'] }
    before do
      ENV['TZ'] = 'UTC'
    end

    after do
      ENV['TZ'] = system_timezone
    end

    it "returns a daily download csv" do
      expect(usage.daily_stats_csv).to eq("Year,Month,Day,Pageviews\n2016,8,4,4\n2016,8,5,8\n2016,8,6,6\n2016,8,7,10\n2016,8,8,2\n")
    end

    it "returns a monthly download csv" do
      expect(usage.monthly_stats_csv).to eq("Year,Month,Pageviews\n2015,9,0\n2015,10,0\n2015,11,0\n2015,12,0\n2016,1,0\n2016,2,0\n2016,3,0\n2016,4,0\n2016,5,0\n2016,6,0\n2016,7,0\n2016,8,30\n")
    end

  end
end
