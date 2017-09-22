module ScholarsArchive
  class OtherOptionCreateSuccessService < Hyrax::AbstractMessageService
    include ActionView::Helpers::UrlHelper
    attr_reader :depositor, :curation_concern, :metadata_element, :entry_text, :work_id, :work_title

    def initialize(curation_concern, field:)
      @curation_concern = curation_concern
      @work_id = curation_concern.id
      @work_title = curation_concern.title.first.to_s
      @depositor = curation_concern.depositor
      @metadata_element = I18n.t("simple_form.labels.defaults.#{field}")
      @entry_text = curation_concern.send("#{field}_other".to_sym)
      super(curation_concern, user_to_notify)
    end

    def message
      "#{depositor} has entered a #{metadata_element} 'Other' entry: #{entry_text}. This entry should be reviewed and added to the controlled vocabulary or rejected/corrected.\n\n Work: #{work_title} (#{link_to work_id, work_path})"
    end

    def subject
      'Degree "Other" entry notification'
    end

    def user_to_notify
      ::User.find_by_email(ENV['SCHOLARSARCHIVE_ADMIN_EMAIL'])
    end

    private

    def work_path
      key = curation_concern.model_name.singular_route_key
      Rails.application.routes.url_helpers.send(key + "_path", curation_concern.id)
    end

  end
end