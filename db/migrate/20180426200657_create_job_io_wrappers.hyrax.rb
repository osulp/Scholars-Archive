class CreateJobIoWrappers < ActiveRecord::Migration[5.0]
  def change
    # A hack put in place because this table was established in earlier releases of
    # Hyrax, then again more recently.. so the table existed in this state in our production
    # database already and would fail to migrate properly.
    unless ActiveRecord::Base.connection.data_source_exists? 'job_io_wrappers'
      create_table :job_io_wrappers do |t|
        t.references :user
        t.references :uploaded_file
        t.string :file_set_id
        t.string :mime_type
        t.string :original_name
        t.string :path
        t.string :relation

        t.timestamps
      end
    end
  end
end
