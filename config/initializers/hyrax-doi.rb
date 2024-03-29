# frozen_string_literal: true
## Set a default host for urls generated by the DOI registrars (if necessary)
# Rails.application.routes.default_url_options[:host] = 'localhost:3000'

## Remote identifiers configuration
# Add registrar implementations by uncommenting and adding to the hash below.
# See app/services/hyrax/identifier/registrar.rb for the registrar interface
Hyrax.config.identifier_registrars = { datacite: Hyrax::DOI::DataCiteRegistrar }

## For DataCite DOIs
# Test mode will use the DataCite test environment
Hyrax::DOI::DataCiteRegistrar.mode = ENV.fetch('DATACITE_MODE', :test).to_sym # Possible options are [:production, :test]
Hyrax::DOI::DataCiteRegistrar.prefix = ENV.fetch('DATACITE_PREFIX', '')
Hyrax::DOI::DataCiteRegistrar.username = ENV.fetch('DATACITE_USERNAME', '')
Hyrax::DOI::DataCiteRegistrar.password = ENV.fetch('DATACITE_PASSWORD', '')
