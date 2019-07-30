Honeycomb.configure do |config|
  config.write_key = ENV.fetch('HONEYCOMB_WRITEKEY', 'fa01b2227f761b5c1f11ae1a680f14da')
  config.dataset = ENV.fetch('HONEYCOMB_DATASET', 'scholars-staging')
  config.notification_events = %w[
    sql.active_record
    render_template.action_view
    render_partial.action_view
    render_collection.action_view
    process_action.action_controller
    send_file.action_controller
    send_data.action_controller
    deliver.action_mailer
  ].freeze

  if %w[test].include? Rails.env
    ENV[HONEYCOMB_DEBUG] = true
  end
end
