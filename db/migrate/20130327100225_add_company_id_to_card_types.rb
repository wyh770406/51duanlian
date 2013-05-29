class AddCompanyIdToCardTypes < ActiveRecord::Migration
  def change
    add_column :card_types, :company_id, :integer
    add_index :card_types, :company_id
  end
end
