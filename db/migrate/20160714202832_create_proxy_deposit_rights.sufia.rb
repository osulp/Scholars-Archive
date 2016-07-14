# This migration comes from sufia (originally 20160328222226)
class CreateProxyDepositRights < ActiveRecord::Migration
  def change
    create_table :proxy_deposit_rights do |t|
      t.references :grantor
      t.references :grantee
      t.timestamps null: false
    end
    add_index :proxy_deposit_rights, :grantor_id
    add_index :proxy_deposit_rights, :grantee_id
  end
end
