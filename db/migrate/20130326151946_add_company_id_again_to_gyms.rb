class AddCompanyIdAgainToGyms < ActiveRecord::Migration
  def change
    add_column :gyms, :company_id, :integer
    add_index :gyms, :company_id
  end
end
