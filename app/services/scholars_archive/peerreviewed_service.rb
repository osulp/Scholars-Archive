# frozen_string_literal: true

module ScholarsArchive
  # checks peer reviewed
  class PeerreviewedService < Hyrax::QaSelectService
    def initialize
      super('peerreviewed')
    end

    def all_labels(values)
      values ||= []
      @authority.all.select { |r| values.include?(r[:id]) }.map { |hash| hash['label'] }
    end

    def select_sorted_all_options
      select_all_options.sort
    end
  end
end
