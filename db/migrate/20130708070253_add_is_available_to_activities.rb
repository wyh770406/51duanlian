class AddIsAvailableToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :is_available, :boolean
    add_index :activities, :is_available

    Activity.all.each do |a|
      a.update_column(:is_available, true)
    end
  end
end
