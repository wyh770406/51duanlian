class AddImportTypeToCsv < ActiveRecord::Migration
  def change
  	add_column :csv_imports, :import_type, :string
  end
end
