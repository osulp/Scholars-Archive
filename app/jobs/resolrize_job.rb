# frozen_string_literal: true

class ResolrizeJob < Hyrax::ApplicationJob
  # Note: Exposing arguments available in ActiveFedora::Base.reindex_everything: batch_size, softCommit, progress_bar and final_commit
  def perform(batch_size: 50, softCommit: true, progress_bar: false, final_commit: false)
    ActiveFedora::Base.reindex_everything(batch_size: batch_size,
                                          softCommit: softCommit,
                                          progress_bar: progress_bar,
                                          final_commit: final_commit)
  end
end
