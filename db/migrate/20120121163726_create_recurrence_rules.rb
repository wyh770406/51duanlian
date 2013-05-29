class CreateRecurrenceRules < ActiveRecord::Migration
  def change
    create_table :recurrence_rules do |t|
      t.string :type
      t.references :date_recurrent, polymorphic: true
      t.references :time_recurrent, polymorphic: true

      t.timestamps
    end

    add_index :recurrence_rules, [:date_recurrent_id, :date_recurrent_type], name: 'index_recurrence_rules_on_date_recurrent'
    add_index :recurrence_rules, [:time_recurrent_id, :time_recurrent_type], name: 'index_recurrence_rules_on_time_recurrent'
  end
end
