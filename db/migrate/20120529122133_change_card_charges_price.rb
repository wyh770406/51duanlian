class ChangeCardChargesPrice < ActiveRecord::Migration
  def up
    change_column :card_charges, :price, :decimal, { :precision => 8, :scale => 2 }
  end

  def down
    change_column :card_charges, :price, :decimal
  end
end
