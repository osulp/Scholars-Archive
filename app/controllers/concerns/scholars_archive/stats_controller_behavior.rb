module ScholarsArchive
  module StatsControllerBehavior
    extend ActiveSupport::Concern
    included do
      include Sufia::SingularSubresourceController
      def work
        @stats = WorkUsageStats.new(params[:id])
      end

      def file
        @stats = FileUsageStats.new(params[:id])
      end

      # routed to /files/:id/daily_stats
      def file_daily_stats
        respond_to do |format|
          format.csv { send_data "#{file_csv_header}#{file.daily_stats_csv}", filename: "file_daily_stats_#{params[:id]}.csv" }
        end
      end

      # routed to /files/:id/monthly_stats
      def file_monthly_stats
        respond_to do |format|
          format.csv { send_data "#{file_csv_header}#{file.monthly_stats_csv}", filename: "file_monthly_stats_#{params[:id]}.csv" }
        end
      end

      # routed to /works/:id/daily_stats
      def work_daily_stats
        respond_to do |format|
          format.csv { send_data "#{work_csv_header}#{work.daily_stats_csv}", filename: "work_daily_stats_#{params[:id]}.csv" }
        end
      end

      # routed to /works/:id/monthly_stats
      def work_monthly_stats
        respond_to do |format|
          format.csv { send_data "#{work_csv_header}#{work.monthly_stats_csv}", filename: "work_monthly_stats_#{params[:id]}.csv" }
        end
      end

      private

        def file_csv_header
          "This file was generated on #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")} and represents statistics for the item  title: #{curation_concern.title.first}\nLocation: /concern/file_sets/#{params[:id]}\n"
        end

        def work_csv_header
          "This file was generated on #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")} and represents statistics for the item  title: #{curation_concern.title.first}\nLocation: /concern/generic_works/#{params[:id]}\n"
        end

    end
  end
end
