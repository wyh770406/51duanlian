class CreateCardCharges < ActiveRecord::Migration
  def change
    create_table :card_charges do |t|
      t.string :name
      t.decimal :price
      t.references :gym

      t.timestamps
    end
    add_index :card_charges, :gym_id
  end
end
