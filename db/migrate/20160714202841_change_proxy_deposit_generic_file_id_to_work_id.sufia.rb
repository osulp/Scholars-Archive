# This migration comes from sufia (originally 20160328222237)
class ChangeProxyDepositGenericFileIdToWorkId < ActiveRecord::Migration
  def change
    rename_column :proxy_deposit_requests, :generic_file_id, :work_id
  end
end
