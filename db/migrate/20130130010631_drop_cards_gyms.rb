class DropCardsGyms < ActiveRecord::Migration
  def change
    drop_table :cards_gyms
  end
end
