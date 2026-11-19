# frozen_string_literal: true

# Workflows Index view helper
module WorkflowsIndexHelper
  def local_time_from_utc(value)
    utc_t = value.to_datetime
    utc_t.in_time_zone(Time.zone).strftime('%Y-%m-%d %H:%M:%S')
  end
end
