class CreateGymImages < ActiveRecord::Migration
  def change
    create_table :gym_images do |t|
      t.references :gym
      t.integer :position
      t.string :image

      t.timestamps
    end
    add_index :gym_images, :gym_id
  end
end
