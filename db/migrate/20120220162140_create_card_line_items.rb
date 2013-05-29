class CreateCardLineItems < ActiveRecord::Migration
  def change
    create_table :card_line_items do |t|
      t.decimal :amount, :precision => 8, :scale => 2
      t.text :reason
      t.references :card

      t.timestamps
    end

    add_index :card_line_items, :card_id
  end
end
