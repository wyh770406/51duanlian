class AddSettingsToRecurrenceRules < ActiveRecord::Migration
  def change
    add_column :recurrence_rules, :settings, :text
  end
end
