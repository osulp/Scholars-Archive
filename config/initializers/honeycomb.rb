Honeycomb.configure do |config|
  config.write_key = <%= ENV.fetch('HONEYCOMB_WRITEKEY', 'fa01b2227f761b5c1f11ae1a680f14da') %>
  config.dataset = <%= ENV.fetch('HONEYCOMB_DATASET', 'scholars-staging') %>
end
