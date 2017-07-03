Hyrax::Actors::BaseActor.class_eval do
  def apply_deposit_date(env)
    if env.attributes['date_uploaded']
      env.curation_concern.date_uploaded = DateTime.strptime(env.attributes['date_uploaded'])
    else
      env.curation_concern.date_uploaded = Hyrax::TimeService.time_in_utc
    end
  end
  def apply_save_data_to_curation_concern(env)
    env.curation_concern.attributes = clean_attributes(env.attributes)
    env.curation_concern.date_uploaded = DateTime.strptime(env.attributes['date_uploaded']) if env.curation_concern.date_uploaded.is_a? String
    if env.attributes['date_modified']
      env.curation_concern.date_modified = DateTime.strptime(env.attributes['date_modified'])
    else
      env.curation_concern.date_modified = Hyrax::TimeService.time_in_utc
    end
  end
end
