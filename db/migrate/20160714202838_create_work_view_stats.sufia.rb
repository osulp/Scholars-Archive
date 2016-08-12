# This migration comes from sufia (originally 20160328222232)
class CreateWorkViewStats < ActiveRecord::Migration
  def change
    create_table :work_view_stats do |t|
      t.datetime :date
      t.integer  :work_views
      t.string   :work_id

      t.timestamps null: false
    end
    add_index :work_view_stats, :work_id
  end
end
