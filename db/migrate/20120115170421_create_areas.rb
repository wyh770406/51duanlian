class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.references :city

      t.timestamps
    end
    add_index :areas, :city_id
  end
end
