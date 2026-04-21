# frozen_string_literal:true

module ScholarsArchive
  # Message and Subject definitions for oEmbed error notifications in Hyrax
  # messaging service
  class OembedErrorService < Hyrax::AbstractMessageService
    attr_reader :user, :messages

    # rubocop:disable Lint/MissingSuper
    def initialize(user, messages)
      @user = user
      @messages = messages.to_sentence
    end
    # rubocop:enable Lint/MissingSuper

    def message
      I18n.t(
        'hyrax.notifications.oembed_error.message',
        messages: messages
      )
    end

    def subject
      I18n.t('hyrax.notifications.oembed_error.subject')
    end
  end
end
