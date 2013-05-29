class AddSoldAtToCards < ActiveRecord::Migration
  def change
    add_column :cards, :sold_at, :datetime

    add_index :cards, :sold_at

    Card.all.each do |card|
      if card.username.present?
        card.sold_at = card.created_at
        card.save
      end
    end
  end
end
