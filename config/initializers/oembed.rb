# frozen_string_literal: true

# Add in an initializer to get all the oembed content onto the controller
require 'oembed'
require 'oembed/providers'

OEmbed::Providers.register_all

## Register OSU Mediaspace Provider
osu_ms_provider = OEmbed::Provider.new('https://media.oregonstate.edu/oembed')
osu_ms_provider << 'https://media.oregonstate.edu/id*'
osu_ms_provider << 'https://media.oregonstate.edu/media/id*'
osu_ms_provider << 'https://media.oregonstate.edu/media/t*'
OEmbed::Providers.register(osu_ms_provider)
