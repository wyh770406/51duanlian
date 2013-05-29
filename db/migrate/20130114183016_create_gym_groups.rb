class CreateGymGroups < ActiveRecord::Migration
  def change
    create_table :gym_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
