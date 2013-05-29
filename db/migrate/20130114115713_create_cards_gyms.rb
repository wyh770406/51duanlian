class CreateCardsGyms < ActiveRecord::Migration
  def up
    create_table :cards_gyms, id: false do |t|
      t.references :card
      t.references :gym
    end

    add_index :cards_gyms, [:card_id, :gym_id]
  end

  def down
    drop_table :cards_gyms
  end
end
