class CreateCardTypes < ActiveRecord::Migration
  def change
    create_table :card_types do |t|
      t.string :name
      t.text :description
      t.references :gym

      t.timestamps
    end
    add_index :card_types, :gym_id
  end
end
