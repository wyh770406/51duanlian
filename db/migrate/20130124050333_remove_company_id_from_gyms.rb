class RemoveCompanyIdFromGyms < ActiveRecord::Migration
  def change
    remove_column :gyms, :company_id
  end
end
