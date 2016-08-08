require 'spec_helper'
require 'rails_helper'

describe FileUsageStats, type: :model do
  let(:file) do
    FileSet.new.tap do |file|
      file.apply_depositor_metadata("bla")
      file.save
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

  # This is what the data looks like that's returned from Google Analytics (GA) via the Legato gem
  # Due to the nature of querying GA, testing this data in an automated fashion is problematc.
  # Sample data structures were created by sending real events to GA from a test instance of
  # Scholarsphere.  The data below are essentially a "cut and paste" from the output of query
  # results from the Legato gem.

  let(:sample_download_statistics) {
    [
      OpenStruct.new(eventCategory: "Files", eventAction: "Downloaded", eventLabel: "sufia:x920fw85p", date: date_strs[0], totalEvents: "1"),
      OpenStruct.new(eventCategory: "Files", eventAction: "Downloaded", eventLabel: "sufia:x920fw85p", date: date_strs[1], totalEvents: "1"),
      OpenStruct.new(eventCategory: "Files", eventAction: "Downloaded", eventLabel: "sufia:x920fw85p", date: date_strs[2], totalEvents: "2"),
      OpenStruct.new(eventCategory: "Files", eventAction: "Downloaded", eventLabel: "sufia:x920fw85p", date: date_strs[3], totalEvents: "3"),
      OpenStruct.new(eventCategory: "Files", eventAction: "Downloaded", eventLabel: "sufia:x920fw85p", date: date_strs[4], totalEvents: "5")
    ]
  }

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
    allow_any_instance_of(FileSet).to receive(:create_date).and_return((Time.zone.today - 4.days).to_s)
    expect(FileDownloadStat).to receive(:ga_statistics).and_return(sample_download_statistics)
    expect(FileViewStat).to receive(:ga_statistics).and_return(sample_pageview_statistics)
    described_class.new(file.id)
  }

  describe "statistics" do
    before(:all) do
      @system_timezone = ENV['TZ']
      ENV['TZ'] = 'UTC'
    end

    after(:all) do
      ENV['TZ'] = @system_timezone
    end

    it "returns a daily download csv" do
      expect(usage.daily_stats_csv).to eq("Year,Month,Day,Pageviews,Downloads\n2016,8,4,4,1\n2016,8,5,8,1\n2016,8,6,6,2\n2016,8,7,10,3\n2016,8,8,2,5\n")
    end

    it "returns a monthly download csv" do
      expect(usage.monthly_stats_csv).to eq("Year,Month,Pageviews,Downloads\n2015,9,0,0\n2015,10,0,0\n2015,11,0,0\n2015,12,0,0\n2016,1,0,0\n2016,2,0,0\n2016,3,0,0\n2016,4,0,0\n2016,5,0,0\n2016,6,0,0\n2016,7,0,0\n2016,8,30,12\n")
    end
  end

end
