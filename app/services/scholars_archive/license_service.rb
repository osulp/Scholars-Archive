module ScholarsArchive
  # Provide select options for the copyright status (edm:rights) field
  class LicenseService < Hyrax::QaSelectService
    def initialize
      super('licenses')
    end

    def all_labels(values)
      authority.all.select { |r| values.include?(r[:id]) }.map { |hash| hash["label"] }
    end

    def select_active_options_from_model(f)
      if f.object.model.class == GraduateThesisOrDissertation || f.object.model.class == UndergraduateThesisOrProject
        select_active_options.select { |license| license.first != "CC0 1.0 Universal" }
      else
        select_active_options
      end
    end

    def include_current_value(value, _index, render_options, html_options)
      unless value.blank? || active?(value)
        html_options[:class] << ' force-select'
        render_options += [[label(value), value]]
      end
      [render_options, html_options]
    end
  end
end
