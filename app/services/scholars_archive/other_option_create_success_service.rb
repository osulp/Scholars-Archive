# frozen_string_literal: true

module ScholarsArchive
  # Create other option
  class OtherOptionCreateSuccessService < Hyrax::AbstractMessageService
    include ActionView::Helpers::UrlHelper
    attr_reader :depositor, :curation_concern, :metadata_field, :new_entries, :work_id, :work_title

    def initialize(curation_concern, field:, new_entries:)
      @curation_concern = curation_concern
      @work_id = curation_concern.id
      @work_title = curation_concern.title.first.to_s
      @depositor = curation_concern.depositor
      @metadata_field = field
      @new_entries = new_entries
      super(curation_concern, user_to_notify)
    end

    def message
      "#{depositor} has entered one or more #{metadata_element} 'Other' entries: #{entries_text}. These entries should be reviewed and added to the controlled vocabulary or rejected/corrected.\n\n Work: #{work_title} (#{link_to work_id, work_path})"
    end

    def subject
      "#{metadata_element} \"Other\" entry notification"
    end

    def user_to_notify
      ::User.find_by_email(ENV['SCHOLARSARCHIVE_ADMIN_EMAIL'])
    end

    private

    def metadata_element
      I18n.t("simple_form.labels.defaults.#{metadata_field}")
    end

    def entries_text
      if ScholarsArchive::FormMetadataService.multiple? curation_concern.to_model.class,metadata_field.to_sym
        new_entries.to_a.join(', ')
      else
        new_entries.to_s
      end
    end

    def work_path
      Rails.application.routes.url_helpers.url_for(:only_path => false, :action => 'show', :controller => 'hyrax/'+curation_concern.model_name.plural, :host=> Rails.application.config.action_mailer.default_url_options[:host], protocol: 'https', id: work_id)
    end
  end
end
