class CreateFavoriteCollection < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_collections do |t|
      t.string :user_id, index: true, null: false
      t.string :collection_id, index: true, null: false
      t.string :name
    end
  end
end
