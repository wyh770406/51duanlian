class AddCompanyIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :company_id, :integer
    add_index :cards, :company_id
  end
end
