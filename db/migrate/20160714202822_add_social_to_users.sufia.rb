# This migration comes from sufia (originally 20160328222156)
class AddSocialToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_handle, :string
    add_column :users, :twitter_handle, :string
    add_column :users, :googleplus_handle, :string
  end

  def self.down
    remove_column :users, :facebook_handle, :string
    remove_column :users, :twitter_handle, :string
    remove_column :users, :googleplus_handle, :string
  end
end
