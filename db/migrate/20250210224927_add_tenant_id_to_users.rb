class AddTenantIdToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :tenant_id, :integer
    add_index :users, :tenant_id
  end
end
