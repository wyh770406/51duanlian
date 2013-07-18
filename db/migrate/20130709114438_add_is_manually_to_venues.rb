class AddIsManuallyToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :is_manually, :boolean
    add_index :venues, :is_manually

    Venue.all.each do |v|
      v.update_column(:is_manually, false)
    end
  end
end
