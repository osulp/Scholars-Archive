# frozen_string_literal: true

module ScholarsArchive
  # A common base class for all ScholarsArchive jobs.
  # This allows downstream applications to manipulate all the ScholarsArchive jobs by
  # including modules on this class.
  class ApplicationJob < ActiveJob::Base
  end
end
