if Rails.env.staging? || Rails.env.production?
  ClamAV.instance.loaddb if defined? ClamAV
end