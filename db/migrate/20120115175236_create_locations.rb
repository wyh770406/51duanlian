class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address
      t.string :zip_code
      t.references :locatable, polymorphic: true
      t.references :area

      t.timestamps
    end
    add_index :locations, [:locatable_id, :locatable_type]
    add_index :locations, :area_id
  end
end
