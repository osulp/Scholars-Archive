class AddPersonAPIToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :api_person_type, :string
    add_column :users, :api_student_type, :string
    add_column :users, :api_person_updated_at, :datetime
  end
end
