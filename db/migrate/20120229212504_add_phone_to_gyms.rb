class AddPhoneToGyms < ActiveRecord::Migration
  def change
    add_column :gyms, :phone, :string

  end
end
