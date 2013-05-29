class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :type
      t.string :name
      t.string :display_on
      t.boolean :active
      t.datetime :deleted_at
      t.text     :settings

      t.timestamps
    end
  end
end
