class AddValidityToCardLineItems < ActiveRecord::Migration
  def change
    add_column :card_line_items, :validity, :integer

  end
end
