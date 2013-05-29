class RemoveTimesFromActivities < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.remove :open_at
      t.remove :close_at
    end
  end
end
