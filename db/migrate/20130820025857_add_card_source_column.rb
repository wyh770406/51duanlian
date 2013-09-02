class AddCardSourceColumn < ActiveRecord::Migration
  def change
  	add_column :cards, :gym_id, :integer

  	add_index :cards, :gym_id
  end
end
