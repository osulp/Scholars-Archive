# frozen_string_literal: true

# resolrizes everything
class ResolrizeJob < Hyrax::ApplicationJob
  queue_as :reindex

  # NOTE: Exposing arguments available in ActiveFedora::Base.reindex_everything: batch_size, softCommit, progress_bar and final_commit
  def perform(batch_size: 50, soft_commit: true, progress_bar: false, final_commit: false)
    ActiveFedora::Base.reindex_everything(batch_size: batch_size,
                                          softCommit: soft_commit,
                                          progress_bar: progress_bar,
                                          final_commit: final_commit)
  end
end
