# frozen_string_literal: true

module ScholarsArchive
  # Provide select options for the degree_levels (untl:degree-information/#level) field
  class DegreeLevelService < Hyrax::QaSelectService
    def initialize
      super('degree_level')
    end

    def select_sorted_all_options
      select_all_options.sort
    end

    def work_type_limited_options(work_type)
      case work_type
      when "UndergraduateThesisOrProject"
        select_all_options.sort.select! { |opt| opt.first.include?("Batchelor's") }
      when "GraduateProject"
        select_all_options.sort.select! { |opt| opt.first.include?("Master's") }
      when "GraduateThesisOrDissertation"
        select_all_options.sort.select! { |opt| opt.first.include?("Doctoral") || opt.first.include?("Master's") }
      when "HonorsCollegeThesis"
        select_all_options.sort.select! { |opt| opt.first.include?("Doctoral") || opt.first.include?("Master's") }
      when "PurchasedEResource"
        select_all_options.sort.select! { |opt| opt.first.include?("Doctoral") || opt.first.include?("Master's") }
      else
        select_all_options.sort
      end
    end
  end
end
