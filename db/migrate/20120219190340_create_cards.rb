class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :number
      t.string :name
      t.string :username
      t.string :email
      t.string :mobile
      t.decimal :balance, :precision => 8, :scale => 2
      t.references :user
      t.references :gym

      t.timestamps
    end
    add_index :cards, :user_id
    add_index :cards, :gym_id
    add_index :cards, :number
    add_index :cards, :email
    add_index :cards, :mobile
  end
end
