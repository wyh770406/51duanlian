class AddIsAvailableToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :is_available, :boolean
    add_index :venues, :is_available

    Venue.all.each do |v|
      v.update_column(:is_available, true)
    end
  end
end
