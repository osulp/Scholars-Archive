module ScholarsArchive
  class PeerreviewedService < Hyrax::QaSelectService
    def initialize
      super('peerreviewed')
    end

    def all_labels(values)
      values ||= []
      @authority.all.select { |r| values.include?(r[:id]) }.map { |hash| hash['label'] }
    end
  end
end
