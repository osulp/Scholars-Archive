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
      active_options = select_active_options
      f.object.model.excluded_licenses.each do |option|
        active_options.delete_if { |license| license.first == option }
      end
      active_options
    end

    def include_current_value(value, _index, render_options, html_options)
      unless value.blank? || active?(value)
        html_options[:class] << ' force-select'
        render_options += [[label(value), value]]
      end
      [render_options, html_options]
    end

    def select_sorted_all_options
      select_all_options.sort
    end
  end
end
