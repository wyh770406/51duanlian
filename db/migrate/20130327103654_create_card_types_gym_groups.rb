class CreateCardTypesGymGroups < ActiveRecord::Migration
  def change
    create_table :card_types_gym_groups, :id => false do |t|
      t.integer :card_type_id
      t.integer :gym_group_id
    end

    add_index :card_types_gym_groups, [:card_type_id, :gym_group_id]
  end
end
