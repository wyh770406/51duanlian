class AddCompanyIdToGymGroups < ActiveRecord::Migration
  def change
    add_column :gym_groups, :company_id, :integer
    add_index :gym_groups, :company_id
  end
end
