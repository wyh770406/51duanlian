class RemoveAvailableDatesFromActivities < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.remove :available_from
      t.remove :available_to
    end
  end
end
