class AddSlugToTenants < ActiveRecord::Migration[6.1]
  def change
    add_column :tenants, :slug, :string
    add_index :tenants, :slug, unique: true
  end
end
