module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def human_readable_date_edtf(options)
    value = options[:value].first
    date = Date.edtf(value)
    if date.instance_of? EDTF::Interval
      output = date.from.edtf + ' to ' + date.to.edtf
    elsif date.present?
      output = date.edtf
    else
      output = value
    end
    return output
  end
end
