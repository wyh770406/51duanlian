class AddCompanyIdToCardCharges < ActiveRecord::Migration
  def change
    add_column :card_charges, :company_id, :integer
    add_index :card_charges, :company_id
  end
end
