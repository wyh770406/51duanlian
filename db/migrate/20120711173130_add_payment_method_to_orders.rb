class AddPaymentMethodToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :payment_method_id, :integer

    add_index :orders, :payment_method_id

    Order.all.each do |o|
      o.update_attribute(:payment_method, o.payments.with_state(:successful).order(:created_at).last.try(:payment_method))
    end
  end
end
