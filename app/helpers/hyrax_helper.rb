module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def human_readable_date_edtf(options)
    value = options[:value].first
    edtf = Date.edtf(value)
    if edtf.instance_of? EDTF::Interval
      output = edtf.from.to_formatted_s(:standard) + ' to ' + edtf.to.to_formatted_s(:standard)
    elsif edtf.instance_of? Date
      output = edtf.to_formatted_s(:standard)
    else
      output = value
    end
    return output
  end
end
