# This migration comes from curation_concerns (originally 20160328222154)
class CreateSingleUseLinks < ActiveRecord::Migration
  def change
    create_table :single_use_links do |t|
      t.string :downloadKey
      t.string :path
      t.string :itemId
      t.datetime :expires

      t.timestamps null: false
    end
  end
end
