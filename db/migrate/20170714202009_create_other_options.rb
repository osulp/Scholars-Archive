class CreateOtherOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :other_options do |t|
      t.string :work_id
      t.string :name
      t.string :property_name

      t.timestamps
    end
    add_index :other_options, :work_id
    add_index :other_options, :name
  end
end
