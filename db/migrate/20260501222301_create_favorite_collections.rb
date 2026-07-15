class CreateFavoriteCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_collections do |t|
      t.integer :user_id, null: false
      t.string :collection_id, null: false
      t.timestamps
    end

    add_index :favorite_collections, :user_id
    add_index :favorite_collections, [:user_id, :collection_id], unique: true
  end
end
