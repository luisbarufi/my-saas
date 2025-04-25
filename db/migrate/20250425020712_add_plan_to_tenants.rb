class AddPlanToTenants < ActiveRecord::Migration[6.1]
  def change
    add_column :tenants, :plan, :string, null: false, default: "solo"
    add_index :tenants, :plan
  end
end
