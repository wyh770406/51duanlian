class AddActiveToVenues < ActiveRecord::Migration
  def up
    add_column :venues, :active, :boolean
    add_index :venues, :active

    Venue.all.each do |venue|
      venue.update_column(:active, true)
    end
  end

  def down
    remove_column :venues, :active
  end
end
