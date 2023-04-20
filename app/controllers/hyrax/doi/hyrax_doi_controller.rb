# frozen_string_literal: true
module Hyrax
  module DOI
    class HyraxDOIController < ApplicationController
      before_action :check_authorization

      def create_draft_doi
        if Flipflop.enabled?(:doi_minting)
          draft_doi = mint_draft_doi

          respond_to do |format|
            format.js { render js: autofill_field(doi_attribute_name, draft_doi), status: :created }
            format.json { render_json_response(response_type: :created, options: { data: draft_doi }) }
          end
        else
          respond_to do |format|
            format.js { render plain: I18n.t("errors.doi_minting.disabled"), status: :internal_error }
            format.json { render_json_response(response_type: :internal_error, message: I18n.t("errors.doi_minting.disabled")) }
          end
        end
      rescue Hyrax::DOI::DataCiteClient::Error => e
        respond_to do |format|
          format.js { render plain: e.message, status: :internal_server_error }
          format.json { render_json_response(response_type: :internal_error, message: e.full_message) }
        end
      end

      def autofill
        doi = params['doi']

        respond_to do |format|
          format.js { render js: autofill_js(doi), status: :ok }
        end
      rescue Hyrax::DOI::NotFoundError => e
        respond_to do |format|
          format.js { render plain: e.message, status: :internal_server_error }
        end
      end

      private

      def check_authorization
        raise Hydra::AccessDenied unless current_ability.can_create_any_work?
      end

      def mint_draft_doi
        doi_registrar.mint_draft_doi
      end

      def doi_registrar
        # TODO: generalize this
        Hyrax::Identifier::Registrar.for(:datacite, {})
      end

      def use_sandbox
        !doi_registrar.mode.equal?(:production)
      end

      def field_selector(attribute_name)
        ".#{params[:curation_concern]}_#{attribute_name}"
      end

      def doi_attribute_name
        params[:attribute] || "doi"
      end

      def hyrax_work_from_doi(doi)
        # TODO: generalize this
        meta = Bolognese::Metadata.new(input: doi,
                                       from: "datacite",
                                       sandbox: use_sandbox)
        # Check that a record was actually loaded
        raise Hyrax::DOI::NotFoundError, "DOI (#{doi}) could not be found." if meta.blank? || meta.doi.blank?
        meta.types["hyrax"] = params['curation_concern'].camelize
        meta.hyrax_work
      end

      # TODO: Move this out to a partial that gets rendered?
      def autofill_js(doi)
        # TODO: Need to wipe old data or is this just supplemental?
        js = "var event = new Event('change');\n" + hyrax_work_from_doi(doi).attributes.collect { |k, v| autofill_field(k, v) }.reject(&:blank?).join("\n")
        js << "document.location = '#metadata';"
      end

      # TODO: Move this out to a partial that gets rendered?
      def autofill_field(attribute_name, value)
        js = []
        # TODO: add error handling in the JS so an error doesn't leave the autofilling incomplete
        Array(value).each_with_index do |v, index|
          # Is this the right way to do this?
          # Need to be smarter to see if all repeated fields are filled before trying to create a new one by clicking?
          if attribute_name.start_with?('date_')
            js << "document.querySelectorAll('#new_date_type')[0].value = '#{helpers.escape_javascript(attribute_name)}'"
            js << "document.querySelectorAll('#new_date_type')[0].dispatchEvent(event)"
            js << "document.querySelectorAll('#{field_selector(attribute_name)} .form-control:not(.index)')[#{index}].value = '#{helpers.escape_javascript(v)}';"
          elsif attribute_name.include? 'keyword'
            keyword_field = "nested_ordered_additional_information";
            js << "document.querySelectorAll('#{field_selector(keyword_field)} .form-control:not(.index)')[0].value += '#{helpers.escape_javascript(v)}\\n'"
            # dataset_nested_ordered_additional_information
          else
            js << "document.querySelectorAll('#{field_selector(attribute_name)} button.add')[0].click();" unless index.zero?
            js << "document.querySelectorAll('#{field_selector(attribute_name)} .form-control:not(.index)')[#{index}].value = '#{helpers.escape_javascript(v)}';"
          end
        end unless attribute_name.include? 'identifier'
        js.reject(&:blank?).join("\n")
      end

      # Override of Hyrax method (See https://github.com/samvera/hyrax/pull/4495)
      # render a json response for +response_type+
      def render_json_response(response_type: :success, message: nil, options: {})
        json_body = Hyrax::API.generate_response_body(response_type: response_type, message: message, options: options)
        render json: json_body, status: Hyrax::API.default_responses[response_type][:code]
      end
    end
  end
end
