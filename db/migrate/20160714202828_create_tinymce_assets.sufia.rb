# This migration comes from sufia (originally 20160328222163)
class CreateTinymceAssets < ActiveRecord::Migration
  def change
    create_table :tinymce_assets do |t|
      t.string :file
      t.timestamps null: false
    end
  end
end
