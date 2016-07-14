# This migration comes from sufia (originally 20160328222162)
class AddLinkedinToUsers < ActiveRecord::Migration
  def change
    add_column :users, :linkedin_handle, :string
  end
end
