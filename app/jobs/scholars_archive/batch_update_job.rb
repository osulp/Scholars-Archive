module ScholarsArchive
  class BatchUpdateJob
    include Hydra::PermissionsQuery
    include Sufia::Messages

    def queue_name
      :batch_update
    end

    attr_accessor :login, :title, :file_attributes, :batch_id, :visibility, :saved, :denied, :embargo_release_date, :visibility_during_embargo,
      :visibility_after_embargo

    def initialize(login, batch_id, title, file_attributes, visibility, embargo_release_date=nil, visibility_during_embargo=nil,
                   visibility_after_embargo=nil)
      self.login = login
      self.title = title || {}
      self.file_attributes = file_attributes
      self.visibility = visibility
      self.embargo_release_date = embargo_release_date
      self.visibility_during_embargo = visibility_during_embargo
      self.visibility_after_embargo = visibility_after_embargo
      self.batch_id = batch_id
      self.saved = []
      self.denied = []
    end

    def run
      batch = Batch.find_or_create(self.batch_id)
      user = User.find_by_user_key(self.login)
      batch.generic_files.each do |gf|
        update_file(gf, user)
      end

      batch.update(status: ["Complete"])

    end

    def update_file(gf, user)
      unless user.can? :edit, gf
        ActiveFedora::Base.logger.error "User #{user.user_key} DENIED access to #{gf.id}!"
        denied << gf
        return
      end
      gf.title = title[gf.id] if title[gf.id]

      transform_uri_params 

      gf.attributes = file_attributes
      gf.visibility = visibility unless visibility == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO
      if visibility == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO
        gf.apply_embargo(embargo_release_date, visibility_during_embargo, visibility_after_embargo)
      end
      save_tries = 0
      begin
        gf.save!
      rescue RSolr::Error::Http => error
        save_tries += 1
        ActiveFedora::Base.logger.warn "BatchUpdateJob caught RSOLR error on #{gf.id}: #{error.inspect}"
        # fail for good if the tries is greater than 3
        raise error if save_tries >=3
        sleep 0.01
        retry
      end #

      Sufia.queue.push(ContentUpdateEventJob.new(gf.id, login))
      saved << gf
    end

    def transform_uri_params
      file_attributes.each_pair do |key, value|
        val_array = []
        if (value.is_a? Hash || key == "rights")
        else
          value.each do |val|
            if MaybeURI.new(val).uri?
              val_array << TriplePoweredResource.new(RDF::URI(val))
            else
              val_array << val
            end
          end
          file_attributes[key] = val_array
        end
      end
    end

  end
end
