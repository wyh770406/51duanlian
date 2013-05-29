class AssociateCardWithCardType < ActiveRecord::Migration
  def change
    add_column :cards, :card_type_id, :integer
    remove_column :cards, :name
    
    add_column :cards, :start_on, :date
    add_column :cards, :stop_on, :date

    add_index :cards, :card_type_id
    add_index :cards, :start_on
    add_index :cards, :stop_on
  end
end
