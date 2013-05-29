class CreateGyms < ActiveRecord::Migration
  def change
    create_table :gyms do |t|
      t.string :name
      t.text :description
      t.datetime :open_at
      t.datetime :close_at
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
