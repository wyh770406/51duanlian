class CsvImport < ActiveRecord::Migration
  def change
    create_table :csv_imports do |t|
      t.references :gym
      t.string :csv

      t.timestamps
    end
    add_index :csv_imports, :gym_id
  end
end
