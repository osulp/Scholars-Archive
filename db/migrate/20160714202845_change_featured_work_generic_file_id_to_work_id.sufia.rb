# This migration comes from sufia (originally 20160510000007)
class ChangeFeaturedWorkGenericFileIdToWorkId < ActiveRecord::Migration
  def change
    return unless column_exists?(:featured_works, :generic_file_id)
    rename_column :featured_works, :generic_file_id, :work_id
  end
end
