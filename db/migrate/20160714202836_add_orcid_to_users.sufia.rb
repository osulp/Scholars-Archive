# This migration comes from sufia (originally 20160328222230)
class AddOrcidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :orcid, :string
  end
end
